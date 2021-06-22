package com.codesquad.issuetracker.issue.controller;

import com.codesquad.issuetracker.comment.dto.CommentResponse;
import com.codesquad.issuetracker.comment.vo.Emoji;
import com.codesquad.issuetracker.comment.vo.Emojis;
import com.codesquad.issuetracker.issue.domain.Comment;
import com.codesquad.issuetracker.issue.dto.IssueCountResponse;
import com.codesquad.issuetracker.issue.dto.IssueDetailResponse;
import com.codesquad.issuetracker.issue.dto.IssueResponse;
import com.codesquad.issuetracker.issue.dto.IssueResponses;
import com.codesquad.issuetracker.label.controller.LabelDummyData;
import com.codesquad.issuetracker.milestone.controller.MilestoneDummyData;
import com.codesquad.issuetracker.user.controller.UserDummyData;

import java.time.LocalDateTime;
import java.util.Arrays;

public class IssueDummyData {
    private IssueDummyData() {
    }

    public static IssueResponses issueResponses() {
        return IssueResponses.from(
                Arrays.asList(
                        IssueResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .description("description설명")
                                .hasSameAuthorComments(true)
                                .createDateTime(LocalDateTime.now())
                                .author(UserDummyData.userResponseFreddie())
                                .assignees(UserDummyData.usersResponses())
                                .labels(LabelDummyData.labelResponses())
                                .milestone(MilestoneDummyData.openedMilestoneResponse())
                                .build()
                )
        );
    }

    public static IssueDetailResponse issueDetailResponse() {
        return IssueDetailResponse.builder()
                       .id(1L)
                       .number(1L)
                       .title("title")
                       .createDateTime(LocalDateTime.now())
                       .author(UserDummyData.userResponseHiro())
                       .assignees(UserDummyData.usersResponses())
                       .labels(LabelDummyData.labelResponses())
                       .milestone(MilestoneDummyData.openedMilestoneResponse())
                       .mainComment(CommentResponse.from(commentByFreddie()))
                       .build();
    }

    public static IssueCountResponse issueCountResponse() {
        return IssueCountResponse.builder()
                       .openedIssueCount(3)
                       .closedIssueCount(2)
                       .build();
    }

    public static Comment commentByFreddie() {
        return Comment.builder()
                       .id(1L)
                       .author(UserDummyData.userFreddie())
                       .contents("commentByFreddie")
                       .createDateTime(LocalDateTime.of(2021, 06, 22, 16, 01))
                       .emojis(Emojis.from(Arrays.asList(
                               Emoji.builder()
                                       .value("😀")
                                       .count(2)
                                       .build(),
                               Emoji.builder()
                                       .value("😂")
                                       .count(2)
                                       .build()
                       )))
                       .build();
    }

    public static Comment commentByHiro() {
        return Comment.builder()
                       .id(2L)
                       .author(UserDummyData.userHiro())
                       .contents("commentByHiro")
                       .createDateTime(LocalDateTime.of(2021, 06, 22, 16, 00))
                       .emojis(Emojis.from(Arrays.asList(
                               Emoji.builder()
                                       .value("😀")
                                       .count(2)
                                       .build(),
                               Emoji.builder()
                                       .value("😂")
                                       .count(2)
                                       .build()
                       )))
                       .build();
    }
}
