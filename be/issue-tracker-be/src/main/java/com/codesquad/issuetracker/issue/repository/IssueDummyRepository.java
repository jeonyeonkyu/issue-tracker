package com.codesquad.issuetracker.issue.repository;

import com.codesquad.issuetracker.issue.domain.Issues;
import org.springframework.stereotype.Repository;

@Repository
public class IssueDummyRepository implements IssueRepository{
    @Override
    public Issues readAll() {
        return null;
    }
}
