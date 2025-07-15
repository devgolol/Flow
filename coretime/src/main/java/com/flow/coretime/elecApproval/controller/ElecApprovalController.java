package com.flow.coretime.elecApproval.controller;

import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.flow.coretime.elecApproval.model.Document;
import com.flow.coretime.elecApproval.model.ElecApprovalHistory;
import com.flow.coretime.elecApproval.service.ElecApprovalService;
import com.flow.coretime.users.model.User;
import com.flow.coretime.users.service.UserService;

@Controller
@RequestMapping("/elecApproval")
public class ElecApprovalController {
        private final ElecApprovalService elecApprovalService;
        private final UserService userService;

        public ElecApprovalController(ElecApprovalService elecApprovalService, UserService userService) {
                this.elecApprovalService = elecApprovalService;
                this.userService = userService;
        }

        @GetMapping
        public String showElecApproval(@AuthenticationPrincipal UserDetails userDetails, Model model) {
                model.addAttribute("currentUserId", userDetails.getUsername());
                model.addAttribute("currentUserAuthority",
                                userDetails.getAuthorities().stream().findFirst().get().getAuthority().trim());

                String currentUserId = userDetails.getUsername();
                List<Document> pendingApprovals = elecApprovalService.getPendingApprovals(currentUserId);
                model.addAttribute("pendingApprovals", pendingApprovals);

                List<Document> myInProgressDocs = elecApprovalService.getMyInProgressDocuments(currentUserId);
                model.addAttribute("myInProgressDocs", myInProgressDocs);

                return "elecApproval";
        }

        @GetMapping("/new")
        public String showElecApprovalNew(@RequestParam("formType") String formType,
                        @AuthenticationPrincipal UserDetails userDetails, Model model) {
                User currentUser = userService.findById(userDetails.getUsername());
                model.addAttribute("currentUserName", currentUser.getName());
                model.addAttribute("currentUserDepartment", currentUser.getDepartment());
                System.out.println("formType: " + formType);
                if (formType == "vacationRequestForm") {
                        return "vacationRequestForm";
                }
                return "elecApprovalNew";

        }

        @PostMapping("/new")
        public String showElecApprovalNew(@ModelAttribute Document document,
                        @RequestParam("docType") String docType,
                        Model model,
                        @AuthenticationPrincipal UserDetails userDetails) {
                User currentUser = userService.findById(userDetails.getUsername());
                if (docType == "vacationRequestForm") {
                        document.setDocType("휴가신청");
                }

                document.setInitiatorId(currentUser.getId());
                document.setTitle("휴가신청서");
                document.setDraftDate(new Date());
                document.setUpdatedAt(new Date());
                document.setStatus("PENDING");
                document.setInitiatorDepartment(currentUser.getDepartment());
                document.setCurrentApproverName("admin");

                elecApprovalService.createDocumentAndInitialApproval(document, "admin");

                return "redirect:/elecApproval";

        }

        @GetMapping("/detail/{docId}")
        public String detailElecApproval(@PathVariable("docId") int docId,
                        @AuthenticationPrincipal UserDetails userDetails, Model model) {
                Document documentDetail = elecApprovalService.getDocumentById(docId);
                User currentUser = userService.findById(userDetails.getUsername());

                if (documentDetail == null) {
                        return "redirect:/error/404"; // 문서가 없을 경우
                }

                // 1. 상신자 정보 모델에 추가 (JSP에서 사용하기 위함)
                User initiatorUser = userService.findById(documentDetail.getInitiatorId());
                if (initiatorUser != null) {
                        documentDetail.setInitiatorName(initiatorUser.getName());
                        documentDetail.setInitiatorDepartment(initiatorUser.getDepartment());
                        // 필요하다면 initiatorUser.getRank() 등도 Document 모델에 추가하여 JSP로 전달
                        documentDetail.setInitiatorRank(initiatorUser.getRank()); // Document 모델에 initiatorRank 필드 추가 필요
                }

                // 2. 현재 로그인한 사용자가 이 문서의 현재 결재자인지 확인 (JSP의 조건부 렌더링에 사용)
                String currentApproverId = elecApprovalService.getCurrentApproverIdForDocument(docId);

                model.addAttribute("documentDetail", documentDetail);
                model.addAttribute("currentUser", currentUser);
                model.addAttribute("currentApproverId", currentApproverId); // 현재 결재자 ID를 JSP로 전달

                // 3. 결재선 정보를 가져와 모델에 추가
                List<ElecApprovalHistory> approvalHistories = elecApprovalService
                                .getApprovalHistoriesForDocument(docId);

                // JSP에서 결재자 이름/직급을 보여주기 위해 User 정보 JOIN 또는 Service 호출
                for (ElecApprovalHistory history : approvalHistories) {
                        User approverUser = userService.findById(history.getApproverId());
                        if (approverUser != null) {
                                // ApprovalHistory 모델에 approverName, approverRank 필드 추가 필요
                                history.setApproverName(approverUser.getName());
                                history.setApproverRank(approverUser.getRank());
                        }
                }
                // approval_order 순서대로 정렬 (Mapper에서 정렬해오면 더 좋음)
                approvalHistories = approvalHistories.stream()
                                .sorted(Comparator.comparingInt(ElecApprovalHistory::getApprovalOrder))
                                .collect(Collectors.toList());

                model.addAttribute("approvalHistories", approvalHistories);

                // 4. 날짜 포맷팅 (기존 코드 유지)
                SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd (E)");
                SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                if (documentDetail.getDraftDate() != null) {
                        model.addAttribute("formattedDetailDraftDate", sdfDate.format(documentDetail.getDraftDate()));
                }
                if (documentDetail.getUpdatedAt() != null) {
                        model.addAttribute("formattedDetailUpdatedAt",
                                        sdfDateTime.format(documentDetail.getUpdatedAt()));
                }

                return "elecApprovalDetail";
        }

        @PostMapping("/approval/{docId}")
        @ResponseBody // JSON 응답을 위해
        public ResponseEntity<Map<String, String>> approveOrRejectDocument(
                        @PathVariable("docId") int docId,
                        @RequestBody Map<String, String> payload, // { "action": "APPROVED", "comment": "의견" }
                        @AuthenticationPrincipal UserDetails userDetails) {

                String approverId = "admin";
                String action = payload.get("action"); // "APPROVED" 또는 "REJECTED"
                String comment = payload.get("comment");

                if (action == null || (!"APPROVED".equals(action) && !"REJECTED".equals(action))) {
                        return new ResponseEntity<>(
                                        Map.of("status", "error", "message", "유효하지 않은 결재 액션입니다."),
                                        HttpStatus.BAD_REQUEST);
                }

                // 반려 시 의견 필수 검증
                if ("REJECTED".equals(action) && (comment == null || comment.trim().isEmpty())) {
                        return new ResponseEntity<>(
                                        Map.of("status", "error", "message", "반려 시에는 의견을 필수로 입력해야 합니다."),
                                        HttpStatus.BAD_REQUEST);
                }

                try {
                        elecApprovalService.processApproval(docId, approverId, action, comment);
                        String successMessage = "APPROVED".equals(action) ? "결재가 승인되었습니다." : "결재가 반려되었습니다.";
                        return new ResponseEntity<>(
                                        Map.of("status", "success", "message", successMessage),
                                        HttpStatus.OK);
                } catch (IllegalArgumentException e) {
                        // 유효하지 않은 결재 요청 (예: 이미 승인/반려된 문서, 결재자가 아님 등)
                        return new ResponseEntity<>(
                                        Map.of("status", "error", "message", e.getMessage()),
                                        HttpStatus.BAD_REQUEST);
                } catch (Exception e) {
                        // 그 외 예상치 못한 서버 오류
                        return new ResponseEntity<>(
                                        Map.of("status", "error", "message", "서버 오류: " + e.getMessage()),
                                        HttpStatus.INTERNAL_SERVER_ERROR);
                }
        }

}
