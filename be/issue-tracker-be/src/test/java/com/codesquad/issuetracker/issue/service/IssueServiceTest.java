package com.codesquad.issuetracker.issue.service;

import com.codesquad.issuetracker.comment.dto.CommentResponse;
import com.codesquad.issuetracker.comment.dto.CommentResponses;
import com.codesquad.issuetracker.issue.controller.IssueDummyData;
import com.codesquad.issuetracker.issue.domain.Comments;
import com.codesquad.issuetracker.issue.domain.Issue;
import com.codesquad.issuetracker.issue.domain.Issues;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.dto.IssueDetailResponse;
import com.codesquad.issuetracker.issue.dto.IssueResponse;
import com.codesquad.issuetracker.issue.dto.IssueResponses;
import com.codesquad.issuetracker.issue.repository.IssueRepository;
import com.codesquad.issuetracker.label.controller.LabelDummyData;
import com.codesquad.issuetracker.label.dto.LabelResponse;
import com.codesquad.issuetracker.label.dto.LabelResponses;
import com.codesquad.issuetracker.milestone.controller.MilestoneDummyData;
import com.codesquad.issuetracker.milestone.dto.MilestoneResponse;
import com.codesquad.issuetracker.user.controller.UserDummyData;
import com.codesquad.issuetracker.user.dto.UserResponse;
import com.codesquad.issuetracker.user.dto.UserResponses;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.BDDMockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(classes = {IssueService.class})
class IssueServiceTest {

    @MockBean
    private IssueRepository issueRepository;

    private IssueService issueService;

    @BeforeEach
    void setUp() {
        issueService = new IssueService(issueRepository);
    }

    @ParameterizedTest
    @MethodSource("readAllProvider")
    void readAll(User user, Issues given, IssueResponses expected) {

        BDDMockito.given(issueRepository.readAll())
                .willReturn(given);

        IssueResponses actual = issueService.readAll(user);

        for (int i = 0; i < actual.getIssueResponses().size(); i++) {
            thenVerifyIssue(actual.getIssueResponses().get(i), expected.getIssueResponses().get(i));
        }
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> readAllProvider() {
        return Stream.of(
                Arguments.of(
                        UserDummyData.userFreddie(),
                        Issues.of(
                                Issue.builder()
                                        .id(1L)
                                        .number(1L)
                                        .title("title")
                                        .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                        .author(UserDummyData.userFreddie())
                                        .assignees(UserDummyData.users())
                                        .labels(LabelDummyData.labels())
                                        .milestone(MilestoneDummyData.openedMilestone())
                                        .mainComment(IssueDummyData.commentByFreddie())
                                        .build()
                        ),
                        IssueResponses.from(Arrays.asList(
                                IssueResponse.builder()
                                        .id(1L)
                                        .number(1L)
                                        .title("title")
                                        .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                        .author(UserResponse.from(UserDummyData.userFreddie()))
                                        .assignees(UserResponses.from(UserDummyData.users()))
                                        .labels(LabelResponses.from(LabelDummyData.labels()))
                                        .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                        .description(IssueDummyData.commentByFreddie().getContents())
                                        .hasSameAuthorComments(false)
                                        .build()
                        ))
                ),
                Arguments.of(
                        UserDummyData.userFreddie(),
                        Issues.of(
                                Issue.builder()
                                        .id(1L)
                                        .number(1L)
                                        .title("title")
                                        .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                        .author(UserDummyData.userFreddie())
                                        .assignees(UserDummyData.users())
                                        .labels(LabelDummyData.labels())
                                        .milestone(MilestoneDummyData.openedMilestone())
                                        .mainComment(IssueDummyData.commentByFreddie())
                                        .comments(Comments.of(
                                                IssueDummyData.commentByHiro(),
                                                IssueDummyData.commentByFreddie()
                                        ))
                                        .build()
                        ),
                        IssueResponses.from(Arrays.asList(
                                IssueResponse.builder()
                                        .id(1L)
                                        .number(1L)
                                        .title("title")
                                        .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                        .author(UserResponse.from(UserDummyData.userFreddie()))
                                        .assignees(UserResponses.from(UserDummyData.users()))
                                        .labels(LabelResponses.from(LabelDummyData.labels()))
                                        .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                        .description(IssueDummyData.commentByFreddie().getContents())
                                        .hasSameAuthorComments(true)
                                        .build()
                        ))
                ),
                Arguments.of(
                        UserDummyData.userFreddie(),
                        Issues.of(
                                Issue.builder()
                                        .id(1L)
                                        .number(1L)
                                        .title("title")
                                        .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                        .author(UserDummyData.userFreddie())
                                        .assignees(UserDummyData.users())
                                        .labels(LabelDummyData.labels())
                                        .milestone(MilestoneDummyData.openedMilestone())
                                        .mainComment(IssueDummyData.commentByFreddie())
                                        .comments(Comments.of(
                                                IssueDummyData.commentByHiro()
                                        ))
                                        .build()
                        ),
                        IssueResponses.from(Arrays.asList(
                                IssueResponse.builder()
                                        .id(1L)
                                        .number(1L)
                                        .title("title")
                                        .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                        .author(UserResponse.from(UserDummyData.userFreddie()))
                                        .assignees(UserResponses.from(UserDummyData.users()))
                                        .labels(LabelResponses.from(LabelDummyData.labels()))
                                        .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                        .description(IssueDummyData.commentByFreddie().getContents())
                                        .hasSameAuthorComments(false)
                                        .build()
                        ))
                )
        );
    }

    @ParameterizedTest
    @MethodSource("readOneProvider")
    void readOne(Issue given, IssueDetailResponse expected) {
        BDDMockito.given(issueRepository.readById(given.getId()))
                .willReturn(Optional.of(given));

        IssueDetailResponse actual = issueService.readOne(given.getId());

        thenVerifyIssue(actual, expected);
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> readOneProvider() {
        return Stream.of(
                Arguments.of(
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .comments(Comments.of(
                                        IssueDummyData.commentByHiro(),
                                        IssueDummyData.commentByFreddie()
                                ))
                                .build(),
                        IssueDetailResponse.builder().id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .assignees(UserResponses.from(UserDummyData.users()))
                                .labels(LabelResponses.from(LabelDummyData.labels()))
                                .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                .mainComment(CommentResponse.from(IssueDummyData.commentByFreddie()))
                                .comments(CommentResponses.from(Comments.of(
                                        IssueDummyData.commentByHiro(),
                                        IssueDummyData.commentByFreddie()
                                )))
                                .build()
                )
        );
    }

    private void thenVerifyIssue(IssueResponse actual, IssueResponse expected) {
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

    private void thenVerifyIssue(IssueDetailResponse actual, IssueDetailResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getNumber()).isEqualTo(expected.getNumber());
        assertThat(actual.getTitle()).isEqualTo(expected.getTitle());

        verifyComment(actual.getMainComment(), expected.getMainComment());

        List<CommentResponse> actualCommentResponse = actual.getComments().getCommentResponses();
        List<CommentResponse> expectedCommentResponse = expected.getComments().getCommentResponses();

        for (int i = 0; i < actualCommentResponse.size(); i++) {
            verifyComment(actualCommentResponse.get(i), expectedCommentResponse.get(i));
        }

        assertThat(actual.isClosed()).isEqualTo(expected.isClosed());
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

    private void verifyUser(UserResponse actual, UserResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getEmail()).isEqualTo(expected.getEmail());
        assertThat(actual.getName()).isEqualTo(expected.getName());
        assertThat(actual.getProfileImage()).isEqualTo(expected.getProfileImage());
    }

    private void verifyLabel(LabelResponse actual, LabelResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getName()).isEqualTo(expected.getName());
        assertThat(actual.getDescription()).isEqualTo(expected.getDescription());
        assertThat(actual.getColor()).isEqualTo(expected.getColor());
    }

    private void verifyMilestone(MilestoneResponse actual, MilestoneResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getName()).isEqualTo(expected.getName());
        assertThat(actual.getDescription()).isEqualTo(expected.getDescription());
        assertThat(actual.getDueDate()).isEqualTo(expected.getDueDate());
        assertThat(actual.isClosed()).isEqualTo(expected.isClosed());
        assertThat(actual.getOpenedIssueCount()).isEqualTo(expected.getOpenedIssueCount());
        assertThat(actual.getClosedIssueCount()).isEqualTo(expected.getClosedIssueCount());
    }

    private void verifyComment(CommentResponse actual, CommentResponse expected) {
        assertThat(actual.getId()).isEqualTo(expected.getId());
        assertThat(actual.getContents()).isEqualTo(expected.getContents());

        verifyUser(actual.getAuthor(), expected.getAuthor());

        assertThat(actual.getCreateDateTime()).isEqualTo(expected.getCreateDateTime());

        assertThat(actual.getEmojis()).isEqualTo(expected.getEmojis());
    }
}
