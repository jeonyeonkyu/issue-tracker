import React from 'react'
import Button from '@material-ui/core/Button';
import { filterCheckboxListAtom } from '@components/common/atoms/filterAtom';
import { issueTitleInputAtom, issueCommentInputAtom } from '@components/common/atoms/issueInputAtom';
import { inputStyles } from '@components/common/baseStyle/baseStyle';
import { useRecoilState } from '@/utils/myRecoil/useRecoilState';
import API from '@/utils/API';

type FilteredIdType = {
  info: {
    id: number;
  }
}

const SendButton = () => {
  const classes = inputStyles();
  const [checkedItems] = useRecoilState(filterCheckboxListAtom);
  const [titleInputValue] = useRecoilState(issueTitleInputAtom);
  const [commentInputValue] = useRecoilState(issueCommentInputAtom);

  const handleClickSendData = async () => {
    const data = {
      title: titleInputValue,
      mainCommentContents: commentInputValue,
      authorId: 3, //수정필요 
      assigneeIds: checkedItems.manager.map(getCheckedItemId),
      labelIds: checkedItems.label.map(getCheckedItemId),
      milestoneId: checkedItems.milestone.length && checkedItems.milestone[0].id
    };
    console.log(data)
    const responseData = await API.post.issues(data);
    console.log(responseData);
  }

  return (
    <Button color="primary"
      variant="contained"
      className={classes.button}
      onClick={handleClickSendData}>
      완료
    </Button>
  )
}

const getCheckedItemId = ({ info: { id } }: FilteredIdType) => id;

export default SendButton;
