package com.codesquad.issuetracker.label.repository;

import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;

import java.util.Optional;

public interface LabelRepository {
    Labels readAll();

    Optional<Label> readById(long id);

    Label save(Label label);


    void deleteById(long id);
}
