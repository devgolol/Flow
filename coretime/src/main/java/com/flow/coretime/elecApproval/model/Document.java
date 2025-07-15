package com.flow.coretime.elecApproval.model;

import java.util.Date;

import lombok.Data;

@Data
public class Document {
        private int docId;
        private String docType;
        private String title;
        private String status; // Rejected: 반려된, Pending: 결제 대기중
        private Date draftDate;
        private String jsonContent;
        private Date updatedAt;

        // JOIN
        private String initiatorId;
        private String initiatorName;
        private String initiatorRank;
        private String initiatorDepartment;

        // APPROVAL_HISTORY와 USERS 테이블을 JOIN하여 가져올 현재 결재자 정보
        private String currentApproverName; // 현재 결재자 이름 (APPROVER_HISTORY의 approver_id와 USERS.NAME 조인)
}
