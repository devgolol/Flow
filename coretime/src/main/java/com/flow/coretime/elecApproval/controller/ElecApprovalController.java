package com.flow.coretime.elecApproval.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.flow.coretime.elecApproval.model.Document;
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
                String loggedInUserId = userDetails.getUsername();
                List<Document> pendingApprovals = elecApprovalService.getPendingApprovals(loggedInUserId);

                model.addAttribute("pendingApprovals", pendingApprovals);

                List<Document> myInProgressDocs = elecApprovalService.getMyInProgressDocuments(loggedInUserId);
                model.addAttribute("myInProgressDocs", myInProgressDocs);
                for (Document doc : myInProgressDocs) {
                        System.out.println("============================" + doc);
                }

                return "elecApproval";
        }

        @GetMapping("/new")
        public String showElecApprovalNew(@RequestParam("formType") String formType,
                        @AuthenticationPrincipal UserDetails userDetails, Model model) {
                User currentUser = userService.findById(userDetails.getUsername());
                model.addAttribute("currentUserName", currentUser.getName());
                model.addAttribute("currentUserDepartment", currentUser.getDepartment());
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

                elecApprovalService.createDocument(document);

                return "redirect:/elecApproval";

        }

        @GetMapping("/detail/{docId}")
        public String detailElecApproval(@PathVariable("docId") int docId,
                        @AuthenticationPrincipal UserDetails userDetails, Model model) {
                Document documentDetail = elecApprovalService.getDocumentById(docId);
                User currentUser = userService.findById(userDetails.getUsername());
                model.addAttribute("documentDetail", documentDetail);
                model.addAttribute("currentUser", currentUser);

                // 날짜를 보기 좋게 포맷하여 모델에 추가 (필요 시)
                SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd (E)"); // 기안일/수정일용
                SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 필요 시 상세 시간 포함

                if (documentDetail.getDraftDate() != null) {
                        model.addAttribute("formattedDetailDraftDate", sdfDate.format(documentDetail.getDraftDate()));
                }
                if (documentDetail.getUpdatedAt() != null) {
                        model.addAttribute("formattedDetailUpdatedAt",
                                        sdfDateTime.format(documentDetail.getUpdatedAt()));
                }

                // 추가적으로 필요한 데이터 (예: 기안자 이름, 부서 이름 등)를 모델에 추가
                // User initiatorUser = userService.findById(documentDetail.getInitiatorId());
                // if (initiatorUser != null) {
                // model.addAttribute("initiatorName", initiatorUser.getName());
                // model.addAttribute("initiatorDepartmentName", initiatorUser.getDepartment());
                // }
                return "elecApprovalDetail";
        }

}
