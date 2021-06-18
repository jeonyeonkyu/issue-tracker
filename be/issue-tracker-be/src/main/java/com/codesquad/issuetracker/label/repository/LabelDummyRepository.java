package com.codesquad.issuetracker.label.repository;

import com.codesquad.issuetracker.label.domain.Label;
import com.codesquad.issuetracker.label.domain.Labels;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class LabelDummyRepository implements LabelRepository{
    @Override
    public Labels readAll() {
        return null;
    }

    @Override
    public Optional<Label> readById(long id) {
        return Optional.empty();
    }

    @Override
    public Label save(Label label) {
        return null;
    }

    @Override
    public void deleteById(long id) {

    }
}
