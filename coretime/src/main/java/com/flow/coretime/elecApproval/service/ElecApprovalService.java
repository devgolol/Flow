package com.flow.coretime.elecApproval.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flow.coretime.elecApproval.mapper.ElecApprovalMapper;
import com.flow.coretime.elecApproval.mapper.ElecApprovalHistoryMapper;
import com.flow.coretime.elecApproval.model.Document;
import com.flow.coretime.elecApproval.model.ElecApprovalHistory;

@Service
public class ElecApprovalService {

        private final ElecApprovalMapper elecApprovalMapper;
        private final ElecApprovalHistoryMapper elecApprovalHistoryMapper;

        public ElecApprovalService(ElecApprovalMapper elecApprovalMapper,
                        ElecApprovalHistoryMapper elecApprovalHistoryMapper) {
                this.elecApprovalMapper = elecApprovalMapper;
                this.elecApprovalHistoryMapper = elecApprovalHistoryMapper;
        }

        // 수신자의 결재대기 목록
        public List<Document> getPendingApprovals(String currentUserId) {
                return elecApprovalMapper.findPendingApprovalsByApproverId(currentUserId);
        }

        // 상신자의 결재대기 목록
        public List<Document> getMyInProgressDocs(String currentUserId) {
                return elecApprovalMapper.findInProgressDocumentsByInitiatorId(currentUserId);
        }

        // 상신자의 결재승인 목록
        public List<Document> getMyApprovedDocs(String currentUserId) {
                return elecApprovalMapper.findApprovedDocumentsByInitiatorId(currentUserId);
        }

        public void createDocument(Document document) {
                elecApprovalMapper.insertDocument(document);
        }

        // 전자결재 등록하기
        @Transactional
        public void createDocumentAndInitialApproval(Document document, String initialApproverId) {
                elecApprovalMapper.insertDocument(document); // 문서 저장 (docId가 생성됨)

                // 중요: 실제 시스템에서는 initialApproverId를 DB에서 가져오거나
                // 결재 라인 설정 로직을 통해 여러 ApprovalHistory를 미리 생성해야 합니다.
                // 현재는 첫 결재자만 PENDING으로 넣고, 나머지는 'REVIEW' 같은 대기 상태로 넣어두는 방식이 일반적.
                // 여기서는 간소화를 위해 'admin'을 첫 결재자로 가정합니다.

                // 예시: 1단계 결재 라인만 있다고 가정하고 첫 결재자를 바로 PENDING으로
                ElecApprovalHistory initialApproval = new ElecApprovalHistory();
                initialApproval.setDocId(document.getDocId());
                initialApproval.setApproverId(initialApproverId); // 첫 결재자 ID
                initialApproval.setApprovalOrder(1); // 첫 번째 결재 순서
                initialApproval.setAction("PENDING"); // 초기 상태는 PENDING (첫 결재자 대기)
                initialApproval.setActionAt(new Date()); // 대기 시작 시간
                elecApprovalHistoryMapper.insertApprovalHistory(initialApproval);

                // 만약 2단계 결재가 있다면, 미리 다음 결재자를 'REVIEW' 상태로 넣어둘 수 있습니다.
                // ApprovalHistory nextApproval = new ApprovalHistory();
                // nextApproval.setDocId(document.getDocId());
                // nextApproval.setApproverId("secondApproverId"); // 다음 결재자 ID
                // nextApproval.setApprovalOrder(2);
                // nextApproval.setAction("REVIEW"); // '검토' 또는 '대기' 상태로 미리 설정
                // approvalHistoryMapper.insertApprovalHistory(nextApproval);
        }

        public Document getDocumentById(int docId) {
                return elecApprovalMapper.getDocumentById(docId);
        }

        // 문서의 현재 PENDING 상태 결재자 ID 조회
        public String getCurrentApproverIdForDocument(int docId) {
                Optional<ElecApprovalHistory> currentPendingApproval = elecApprovalHistoryMapper
                                .findCurrentPendingApproval(docId);
                return currentPendingApproval.map(ElecApprovalHistory::getApproverId).orElse(null);
        }

        // 문서의 모든 결재 이력 조회 (JSP에서 결재선 동적 표시용)
        public List<ElecApprovalHistory> getApprovalHistoriesForDocument(int docId) {
                return elecApprovalHistoryMapper.findApprovalHistoryByDocId(docId);
        }

        // 결재하기
        @Transactional
        public void processApproval(int docId, String approverId, String action, String comment) {
                Document document = elecApprovalMapper.getDocumentById(docId);
                if (document == null) {
                        throw new IllegalArgumentException("문서를 찾을 수 없습니다. (docId: " + docId + ")");
                }

                // 현재 PENDING 상태의 결재 이력 (현재 결재 대기자)을 가져옴
                Optional<ElecApprovalHistory> currentPendingApprovalOpt = elecApprovalHistoryMapper
                                .findCurrentPendingApproval(docId);

                if (currentPendingApprovalOpt.isEmpty()) {
                        throw new IllegalArgumentException("현재 결재 대기 중인 상태가 아니거나, 잘못된 요청입니다.");
                }

                ElecApprovalHistory currentPendingApproval = currentPendingApprovalOpt.get();

                // 요청한 사용자가 현재 결재자인지, 그리고 해당 이력의 상태가 PENDING인지 확인
                if (!currentPendingApproval.getApproverId().equals(approverId)
                                || !"PENDING".equals(currentPendingApproval.getAction())) {
                        throw new IllegalArgumentException("당신은 이 문서의 현재 결재자가 아니거나, 이미 처리된 문서입니다.");
                }

                // 1. APPROVAL_HISTORY 업데이트: 현재 PENDING 상태를 요청된 액션으로 변경
                currentPendingApproval.setAction(action); // APPROVED 또는 REJECTED
                currentPendingApproval.setCommentText(comment);
                currentPendingApproval.setActionAt(new Date());
                elecApprovalHistoryMapper.updateApprovalHistory(currentPendingApproval);

                // 2. DOCUMENTS 테이블의 상태 업데이트 및 다음 단계 결정
                if ("APPROVED".equals(action)) {
                        // 다음 결재 순서의 결재자를 찾음
                        Optional<ElecApprovalHistory> nextApproverOpt = elecApprovalHistoryMapper.findNextApprover(
                                        docId,
                                        currentPendingApproval.getApprovalOrder());

                        if (nextApproverOpt.isPresent()) {
                                // 다음 결재자가 있다면, 해당 결재자의 상태를 'PENDING'으로 업데이트
                                // (만약 미리 'REVIEW' 등으로 넣어두었다면, 'PENDING'으로 변경)
                                ElecApprovalHistory nextApproverHistory = nextApproverOpt.get();
                                nextApproverHistory.setAction("PENDING"); // 다음 결재자의 상태를 PENDING으로 활성화
                                nextApproverHistory.setActionAt(new Date()); // 다음 결재자의 대기 시작 시간
                                nextApproverHistory.setCommentText(null); // 다음 결재자의 코멘트는 초기화
                                elecApprovalHistoryMapper.updateApprovalHistory(nextApproverHistory);

                                document.setStatus("IN_PROGRESS"); // 문서 상태를 진행 중으로
                        } else {
                                // 다음 결재자가 없다면, 최종 승인
                                document.setStatus("APPROVED"); // 문서 상태를 최종 승인으로
                        }
                } else if ("REJECTED".equals(action)) {
                        // 반려 처리: 문서 상태를 REJECTED로 변경
                        document.setStatus("REJECTED");
                }

                document.setUpdatedAt(new Date()); // 문서 업데이트 시간 변경
                elecApprovalMapper.updateDocumentStatus(document); // 문서 상태 업데이트
        }

}
