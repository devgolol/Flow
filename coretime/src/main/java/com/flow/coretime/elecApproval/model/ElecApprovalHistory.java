package com.flow.coretime.elecApproval.model;

import lombok.Data;
import java.util.Date;

@Data
public class ElecApprovalHistory {
        private int historyId;
        private int docId;
        private String approverId;
        private int approvalOrder;
        private String action; // (WAITING, 아직 차례가 아님), (PENDING, 내 차례인데 아직 처리 안 함)
                               // (APPROVED, 승인됨), (REJECTED, 반려됨),
        private String commentText;
        private Date actionAt;

        // 결재선 표시를 위한 추가 필드 (JOIN 또는 UserService 호출로 채워짐)
        private String approverName; // USERS.NAME
        private String approverRank; // USERS.RANK (User 모델에 rank 필드가 있다면)
}
