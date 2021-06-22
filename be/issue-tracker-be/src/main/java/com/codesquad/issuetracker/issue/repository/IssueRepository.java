package com.codesquad.issuetracker.issue.repository;

import com.codesquad.issuetracker.issue.domain.Issue;
import com.codesquad.issuetracker.issue.domain.Issues;

import java.util.Optional;

public interface IssueRepository {
    Issues readAll();

    Optional<Issue> readById(long id);
}
