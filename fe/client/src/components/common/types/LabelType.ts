export type LabelSwitchType = {
  name: string;
  color: string;
  description: string;
}

export type LabelItemType = LabelSwitchType & {
  setToggleLabel: any;
}