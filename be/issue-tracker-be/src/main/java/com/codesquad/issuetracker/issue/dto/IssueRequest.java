package com.codesquad.issuetracker.issue.dto;

import com.codesquad.issuetracker.issue.domain.Comment;
import com.codesquad.issuetracker.issue.domain.Milestone;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.domain.Users;
import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.label.mapper.LabelDtoMapper;
import com.codesquad.issuetracker.milestone.mapper.MilestoneDtoMapper;
import com.codesquad.issuetracker.user.mapper.UserDtoMapper;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IssueRequest {
    @NotEmpty
    private String title;

    private String mainCommentContents;

    @NotNull
    private Long authorId;

    private Set<Long> assigneeIds;
    private Set<Long> labelIds;
    private Long milestoneId;

    public Comment mainComment() {
        return Comment.builder()
                       .author(author())
                       .contents(mainCommentContents != null ? mainCommentContents : "")
                       .createDateTime(LocalDateTime.now())
                       .build();
    }

    public User author() {
        return UserDtoMapper.toEntity(authorId);
    }

    public Users assignees() {
        return UserDtoMapper.toEntities(assigneeIds);

    }

    public Labels labels() {
        return LabelDtoMapper.toEntities(labelIds);
    }

    public Milestone milestone() {
        return MilestoneDtoMapper.toEntity(milestoneId);
    }
}
