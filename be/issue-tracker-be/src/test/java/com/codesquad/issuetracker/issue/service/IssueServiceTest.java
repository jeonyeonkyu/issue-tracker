package com.codesquad.issuetracker.issue.service;

import com.codesquad.issuetracker.comment.dto.CommentResponse;
import com.codesquad.issuetracker.comment.dto.CommentResponses;
import com.codesquad.issuetracker.common.exception.EntityNotFoundException;
import com.codesquad.issuetracker.issue.controller.IssueDummyData;
import com.codesquad.issuetracker.issue.domain.*;
import com.codesquad.issuetracker.issue.dto.*;
import com.codesquad.issuetracker.issue.repository.IssueRepository;
import com.codesquad.issuetracker.label.controller.LabelDummyData;
import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
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
import java.util.Arrays;
import java.util.HashSet;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThatExceptionOfType;

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
    void readAll(String 테스트케이스설명, User user, Issues given, IssueResponses expected) {

        BDDMockito.given(issueRepository.readAll())
                .willReturn(given);

        IssueResponses actual = issueService.readAll(user);

        for (int i = 0; i < actual.getIssueResponses().size(); i++) {
            IssueTestValidator.thenVerifyIssue(actual.getIssueResponses().get(i), expected.getIssueResponses().get(i));
        }
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> readAllProvider() {
        return Stream.of(
                Arguments.of(
                        "커멘트 존재하지 않음",
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
                        "커멘트 존재",
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
                        "다른 사용자가 작성한 커멘트 존재",
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

        IssueTestValidator.thenVerifyIssue(actual, expected);
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

    @ParameterizedTest
    @MethodSource("readOneEntityNotFoundedProvider")
    void readOneEntityNotFounded(long id) {
        BDDMockito.given(issueRepository.readById(id))
                .willReturn(Optional.empty());

        assertThatExceptionOfType(EntityNotFoundException.class)
                .isThrownBy(() -> {
                    issueService.readOne(id);
                });
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> readOneEntityNotFoundedProvider() {
        return Stream.of(
                Arguments.of(
                        1L
                )
        );
    }

    @ParameterizedTest
    @MethodSource("createProvider")
    void create(String 테스트케이스설명, Issue givenParam, Issue given, IssueRequest issueRequest, IssueDetailResponse expected) {
        BDDMockito.given(issueRepository.save(givenParam))
                .willReturn(given);

        IssueDetailResponse actual = issueService.create(issueRequest);

        IssueTestValidator.thenVerifyIssue(actual, expected);
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> createProvider() {
        return Stream.of(
                Arguments.of(
                        "옵션 모두 존재",
                        Issue.builder()
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
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
                                .build(),
                        IssueRequest.builder()
                                .title("title")
                                .mainCommentContents(IssueDummyData.commentByFreddie().getContents())
                                .authorId(UserDummyData.userFreddie().getId())
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        IssueDetailResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .assignees(UserResponses.from(UserDummyData.users()))
                                .labels(LabelResponses.from(LabelDummyData.labels()))
                                .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                .mainComment(CommentResponse.from(IssueDummyData.commentByFreddie()))
                                .build()
                ), Arguments.of(
                        "마일스톤 제외",
                        Issue.builder()
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
                        IssueRequest.builder()
                                .title("title")
                                .mainCommentContents(IssueDummyData.commentByFreddie().getContents())
                                .authorId(UserDummyData.userFreddie().getId())
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .build(),
                        IssueDetailResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .assignees(UserResponses.from(UserDummyData.users()))
                                .labels(LabelResponses.from(LabelDummyData.labels()))
                                .mainComment(CommentResponse.from(IssueDummyData.commentByFreddie()))
                                .build()
                ), Arguments.of(
                        "라벨 제외",
                        Issue.builder()
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
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
                                .build(),
                        IssueRequest.builder()
                                .title("title")
                                .mainCommentContents(IssueDummyData.commentByFreddie().getContents())
                                .authorId(UserDummyData.userFreddie().getId())
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        IssueDetailResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .assignees(UserResponses.from(UserDummyData.users()))
                                .labels(LabelResponses.from(LabelDummyData.labels()))
                                .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                .mainComment(CommentResponse.from(IssueDummyData.commentByFreddie()))
                                .build()
                ), Arguments.of(
                        "assignee 제외",
                        Issue.builder()
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
                        IssueRequest.builder()
                                .title("title")
                                .mainCommentContents(IssueDummyData.commentByFreddie().getContents())
                                .authorId(UserDummyData.userFreddie().getId())
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        IssueDetailResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .labels(LabelResponses.from(LabelDummyData.labels()))
                                .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                .mainComment(CommentResponse.from(IssueDummyData.commentByFreddie()))
                                .build()
                ), Arguments.of(
                        "커멘트 제외",
                        Issue.builder()
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .build(),
                        IssueRequest.builder()
                                .title("title")
                                .authorId(UserDummyData.userFreddie().getId())
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        IssueDetailResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .assignees(UserResponses.from(UserDummyData.users()))
                                .labels(LabelResponses.from(LabelDummyData.labels()))
                                .milestone(MilestoneResponse.from(MilestoneDummyData.openedMilestone()))
                                .build()
                )
        );
    }

    @ParameterizedTest
    @MethodSource
    void update(String 테스트케이스설명, Issue givenForReadById, Issue givenForSave, IssueUpdateRequest issueUpdateRequest, IssueDetailResponse expected) {
        BDDMockito.given(issueRepository.readById(givenForReadById.getId()))
                .willReturn(Optional.of(givenForReadById));

        BDDMockito.given(issueRepository.save(givenForSave))
                .willReturn(givenForSave);

        IssueDetailResponse actual = issueService.update(givenForReadById.getId(), issueUpdateRequest);

        IssueTestValidator.thenVerifyIssue(actual, expected);
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> update() {
        return Stream.of(
                Arguments.of(
                        "옵션 모두 존재",
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
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title updated")
                                .isClosed(true)
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(Users.of(UserDummyData.userFreddie()))
                                .labels(Labels.of(LabelDummyData.labelBe()))
                                .milestone(MilestoneDummyData.closedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build(),
                        IssueUpdateRequest.builder()
                                .title("title updated")
                                .isClosed(true)
                                .assigneeIds(new HashSet<>(Arrays.asList(UserDummyData.userFreddie().getId())))
                                .labelIds(new HashSet<>(Arrays.asList(LabelDummyData.labelBe().getId())))
                                .milestoneId(MilestoneDummyData.closedMilestone().getId())
                                .build(),
                        IssueDetailResponse.builder()
                                .id(1L)
                                .number(1L)
                                .title("title updated")
                                .isClosed(true)
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserResponse.from(UserDummyData.userFreddie()))
                                .assignees(UserResponses.from(Users.of(UserDummyData.userFreddie())))
                                .labels(LabelResponses.from(Labels.of(LabelDummyData.labelBe())))
                                .milestone(MilestoneResponse.from(MilestoneDummyData.closedMilestone()))
                                .mainComment(CommentResponse.from(IssueDummyData.commentByFreddie()))
                                .build()
                )
        );
    }
}
