package com.codesquad.issuetracker.issue.service;

import com.codesquad.issuetracker.common.exception.EntityNotFoundException;
import com.codesquad.issuetracker.issue.domain.Issue;
import com.codesquad.issuetracker.issue.domain.Issues;
import com.codesquad.issuetracker.issue.domain.User;
import com.codesquad.issuetracker.issue.dto.IssueDetailResponse;
import com.codesquad.issuetracker.issue.dto.IssueRequest;
import com.codesquad.issuetracker.issue.dto.IssueResponses;
import com.codesquad.issuetracker.issue.repository.IssueRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class IssueService {

    private final IssueRepository issueRepository;

    public IssueResponses readAll(User user) {
        Issues issues = issueRepository.readAll();

        return IssueResponses.of(issues, user);
    }

    public IssueDetailResponse readOne(long id) {
        Issue issue = issueRepository.readById(id)
                              .orElseThrow(() -> new EntityNotFoundException());

        return IssueDetailResponse.from(issue);
    }

    public IssueDetailResponse create(IssueRequest issueRequest) {
        Issue issueForSave = Issue.from(issueRequest);

        return IssueDetailResponse.from(issueRepository.save(issueForSave));
    }

    public IssueDetailResponse update(long issueId, IssueRequest issueRequest) {
        Issue issue = issueRepository.readById(issueId)
                              .orElseThrow(() -> new EntityNotFoundException());

        issue.update(issueRequest);

        return IssueDetailResponse.from(issueRepository.save(issue));

    }
}
