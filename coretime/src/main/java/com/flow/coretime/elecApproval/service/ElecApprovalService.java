package com.flow.coretime.elecApproval.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.flow.coretime.elecApproval.mapper.ElecApprovalMapper;
import com.flow.coretime.elecApproval.model.Document;

@Service
public class ElecApprovalService {

        private final ElecApprovalMapper elecApprovalMapper;

        public ElecApprovalService(ElecApprovalMapper elecApprovalMapper) {
                this.elecApprovalMapper = elecApprovalMapper;
        }

        public List<Document> getPendingApprovals(String userId) {
                return elecApprovalMapper.findPendingApprovalsByApproverId(userId);
        }

        public List<Document> getMyInProgressDocuments(String userId) {
                return elecApprovalMapper.findInProgressDocumentsByInitiatorId(userId);
        }

        public void createDocument(Document document) {
                elecApprovalMapper.insertDocument(document);
        }

        public Document getDocumentById(int docId) {
                return elecApprovalMapper.getDocumentById(docId);
        }

}
