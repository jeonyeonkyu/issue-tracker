package com.codesquad.issuetracker.issue.repository;

import com.codesquad.issuetracker.issue.domain.Issues;

public interface IssueRepository {
    Issues readAll();
}
