package com.codesquad.issuetracker.label.repository;

import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;

public interface LabelRepository {
    Labels readAll();

    Label save(Label label);
}
