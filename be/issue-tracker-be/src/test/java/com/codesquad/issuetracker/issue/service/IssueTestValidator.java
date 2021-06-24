package com.codesquad.issuetracker.issue.service;

import com.codesquad.issuetracker.comment.dto.CommentResponse;
import com.codesquad.issuetracker.issue.dto.IssueDetailResponse;
import com.codesquad.issuetracker.issue.dto.IssueResponse;
import com.codesquad.issuetracker.label.dto.LabelResponse;
import com.codesquad.issuetracker.milestone.dto.MilestoneResponse;
import com.codesquad.issuetracker.user.dto.UserResponse;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

public class IssueTestValidator {
    private IssueTestValidator() {
    }

    public static void thenVerifyIssue(IssueResponse actual, IssueResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getNumber()).isEqualTo(expected.getNumber());
        assertThat(actual.getTitle()).isEqualTo(expected.getTitle());
        assertThat(actual.getDescription()).isEqualTo(expected.getDescription());
        assertThat(actual.isClosed()).isEqualTo(expected.isClosed());
        assertThat(actual.isHasSameAuthorComments()).isEqualTo(expected.isHasSameAuthorComments());
        assertThat(actual.getCreateDateTime()).isEqualTo(expected.getCreateDateTime());

        verifyUser(actual.getAuthor(), expected.getAuthor());

        List<UserResponse> actualUserResponses = new ArrayList<>(actual.getAssignees().getUserResponses());
        List<UserResponse> expectedUserResponses = new ArrayList<>(expected.getAssignees().getUserResponses());

        for (int i = 0; i < actualUserResponses.size(); i++) {
            verifyUser(actualUserResponses.get(i), expectedUserResponses.get(i));
        }

        List<LabelResponse> actualLabelResponses = new ArrayList<>(actual.getLabels().getLabelResponses());
        List<LabelResponse> expectedLabelResponses = new ArrayList<>(expected.getLabels().getLabelResponses());

        for (int i = 0; i < actualLabelResponses.size(); i++) {
            verifyLabel(actualLabelResponses.get(i), expectedLabelResponses.get(i));
        }

        verifyMilestone(actual.getMilestone(), expected.getMilestone());
    }

    public static void thenVerifyIssue(IssueDetailResponse actual, IssueDetailResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getNumber()).isEqualTo(expected.getNumber());
        assertThat(actual.getTitle()).isEqualTo(expected.getTitle());

        if (actual.getMainComment() != null && expected.getMainComment() != null) {
            verifyComment(actual.getMainComment(), expected.getMainComment());
        }

        List<CommentResponse> actualCommentResponse = actual.getComments() != null ? actual.getComments().getCommentResponses() : Collections.emptyList();
        List<CommentResponse> expectedCommentResponse = expected.getComments() != null ? expected.getComments().getCommentResponses() : Collections.emptyList();

        for (int i = 0; i < actualCommentResponse.size(); i++) {
            verifyComment(actualCommentResponse.get(i), expectedCommentResponse.get(i));
        }

        assertThat(actual.isClosed()).isEqualTo(expected.isClosed());
        assertThat(actual.getCreateDateTime()).isEqualTo(expected.getCreateDateTime());

        verifyUser(actual.getAuthor(), expected.getAuthor());

        List<UserResponse> actualUserResponses = new ArrayList<>(actual.getAssignees() != null ? actual.getAssignees().getUserResponses() : Collections.emptyList());
        List<UserResponse> expectedUserResponses = new ArrayList<>(expected.getAssignees() != null ? expected.getAssignees().getUserResponses() : Collections.emptyList());

        for (int i = 0; i < actualUserResponses.size(); i++) {
            verifyUser(actualUserResponses.get(i), expectedUserResponses.get(i));
        }

        List<LabelResponse> actualLabelResponses = new ArrayList<>(actual.getLabels().getLabelResponses());
        List<LabelResponse> expectedLabelResponses = new ArrayList<>(expected.getLabels().getLabelResponses());

        for (int i = 0; i < actualLabelResponses.size(); i++) {
            verifyLabel(actualLabelResponses.get(i), expectedLabelResponses.get(i));
        }

        if (actual.getMilestone() != null && expected.getMilestone() != null) {
            verifyMilestone(actual.getMilestone(), expected.getMilestone());
        }
    }

    private static void verifyUser(UserResponse actual, UserResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getEmail()).isEqualTo(expected.getEmail());
        assertThat(actual.getName()).isEqualTo(expected.getName());
        assertThat(actual.getProfileImage()).isEqualTo(expected.getProfileImage());
    }

    private static void verifyLabel(LabelResponse actual, LabelResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getName()).isEqualTo(expected.getName());
        assertThat(actual.getDescription()).isEqualTo(expected.getDescription());
        assertThat(actual.getColor()).isEqualTo(expected.getColor());
    }

    private static void verifyMilestone(MilestoneResponse actual, MilestoneResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getName()).isEqualTo(expected.getName());
        assertThat(actual.getDescription()).isEqualTo(expected.getDescription());
        assertThat(actual.getDueDate()).isEqualTo(expected.getDueDate());
        assertThat(actual.isClosed()).isEqualTo(expected.isClosed());
        assertThat(actual.getOpenedIssueCount()).isEqualTo(expected.getOpenedIssueCount());
        assertThat(actual.getClosedIssueCount()).isEqualTo(expected.getClosedIssueCount());
    }

    private static void verifyComment(CommentResponse actual, CommentResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getContents()).isEqualTo(expected.getContents());

        verifyUser(actual.getAuthor(), expected.getAuthor());

        assertThat(actual.getCreateDateTime()).isEqualTo(expected.getCreateDateTime());

        assertThat(actual.getEmojis()).isEqualTo(expected.getEmojis());
    }
}
