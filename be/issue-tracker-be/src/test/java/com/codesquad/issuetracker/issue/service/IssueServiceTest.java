package com.codesquad.issuetracker.issue.service;

import com.codesquad.issuetracker.issue.repository.IssueRepository;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

@SpringBootTest(classes = {IssueService.class})
class IssueServiceTest {

    @MockBean
    private IssueRepository issueRepository;

    private IssueService issueService;

    @BeforeEach
    void setUp() {
        issueService = new IssueService(issueRepository);
    }
}
