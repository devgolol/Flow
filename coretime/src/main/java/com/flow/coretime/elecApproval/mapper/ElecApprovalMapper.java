package com.flow.coretime.elecApproval.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flow.coretime.elecApproval.model.Document;

@Mapper
public interface ElecApprovalMapper {
        List<Document> findPendingApprovalsByApproverId(@Param("approverId") String approverId);

        List<Document> findInProgressDocumentsByInitiatorId(@Param("initiatorId") String initiatorId);

        void insertDocument(Document document);

        Document getDocumentById(@Param("docId") int docId);
}
