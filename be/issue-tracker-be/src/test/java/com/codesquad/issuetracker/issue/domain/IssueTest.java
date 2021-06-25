package com.codesquad.issuetracker.issue.domain;

import com.codesquad.issuetracker.issue.controller.IssueDummyData;
import com.codesquad.issuetracker.issue.dto.IssueUpdateRequest;
import com.codesquad.issuetracker.issue.mapper.IssueDtoMapper;
import com.codesquad.issuetracker.label.controller.LabelDummyData;
import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
import com.codesquad.issuetracker.milestone.controller.MilestoneDummyData;
import com.codesquad.issuetracker.user.controller.UserDummyData;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static org.assertj.core.api.BDDAssertions.then;

class IssueTest {

    @ParameterizedTest
    @MethodSource("updateProvider")
    void update(String 테스트케이스설명, Issue given, IssueUpdateRequest issueUpdateRequest, Issue expected) {
        Issue actual = given.update(IssueDtoMapper.toEntity(issueUpdateRequest));

        then(actual).isEqualTo(expected)
                .hasFieldOrPropertyWithValue("author", expected.getAuthor())
                .hasFieldOrPropertyWithValue("isClosed", expected.isClosed())
                .hasFieldOrPropertyWithValue("assignees", expected.getAssignees())
                .hasFieldOrPropertyWithValue("labels", expected.getLabels())
                .hasFieldOrPropertyWithValue("milestone", expected.getMilestone());
    }

    @SuppressWarnings("unused")
    static Stream<Arguments> updateProvider() {
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
                        IssueUpdateRequest.builder()
                                .title("title updated")
                                .isClosed(true)
                                .assigneeIds(new HashSet<>(Arrays.asList(UserDummyData.userFreddie().getId())))
                                .labelIds(new HashSet<>(Arrays.asList(LabelDummyData.labelBe().getId())))
                                .milestoneId(MilestoneDummyData.closedMilestone().getId())
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
                                .build()
                ),
                Arguments.of(
                        "제목수정",
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
                        IssueUpdateRequest.builder()
                                .title("title updated")
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title updated")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build()
                ),
                Arguments.of(
                        "상태수정(열림->닫힘)",
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
                        IssueUpdateRequest.builder()
                                .title("title updated")
                                .isClosed(true)
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .isClosed(true)
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build()
                ),
                Arguments.of(
                        "담당자 변경",
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
                        IssueUpdateRequest.builder()
                                .title("title")
                                .assigneeIds(new HashSet<>(Arrays.asList(UserDummyData.userFreddie().getId())))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(Users.of(UserDummyData.userFreddie()))
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build()
                ),
                Arguments.of(
                        "라벨 수정",
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
                        IssueUpdateRequest.builder()
                                .title("title")
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(new HashSet<>(Arrays.asList(LabelDummyData.labelBe().getId())))
                                .milestoneId(MilestoneDummyData.openedMilestone().getId())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(Labels.of(LabelDummyData.labelBe()))
                                .milestone(MilestoneDummyData.openedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build()
                ),
                Arguments.of(
                        "상태수정(열림->닫힘)",
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
                        IssueUpdateRequest.builder()
                                .title("title")
                                .assigneeIds(UserDummyData.users().stream().map(User::getId).collect(Collectors.toSet()))
                                .labelIds(LabelDummyData.labels().stream().map(Label::getId).collect(Collectors.toSet()))
                                .milestoneId(MilestoneDummyData.closedMilestone().getId())
                                .build(),
                        Issue.builder()
                                .id(1L)
                                .number(1L)
                                .title("title")
                                .createDateTime(LocalDateTime.of(2021, 6, 21, 16, 0))
                                .author(UserDummyData.userFreddie())
                                .assignees(UserDummyData.users())
                                .labels(LabelDummyData.labels())
                                .milestone(MilestoneDummyData.closedMilestone())
                                .mainComment(IssueDummyData.commentByFreddie())
                                .build()
                )
        );
    }
}
