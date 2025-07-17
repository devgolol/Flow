package com.flow.coretime.elecApproval.model;

import java.util.Date;

import lombok.Data;

@Data
public class Document {
        // 테이블 컬럼
        private int docId;
        private String docType;
        private String title;
        private String status; // (PENDING, 첫번째 결재자의 승인 대기중), (IN_PROGRESS, 첫 번째 결재자의 승인을 받았고, 다음 결재자의 승인을 기다리고
                               // 있는 상태)
                               // REJECTED: 반려됨, APPROVED: 승인됨
        private Date draftDate;
        private String jsonContent;
        private Date updatedAt;

        // JOIN
        // 테이블: USERS
        private String initiatorId;
        private String initiatorName;
        private String initiatorRank;
        private String initiatorDepartment;

        // 테이블: APPROVAL_HISTORY
        private String currentApproverName;
}
