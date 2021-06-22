package com.codesquad.issuetracker.issue.repository;

import com.codesquad.issuetracker.issue.domain.Issue;
import com.codesquad.issuetracker.issue.domain.Issues;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class IssueDummyRepository implements IssueRepository {
    @Override
    public Issues readAll() {
        return null;
    }

    @Override
    public Optional<Issue> readById(long id) {
        return null;
    }
}
