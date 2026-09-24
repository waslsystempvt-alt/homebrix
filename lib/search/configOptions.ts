export interface ConfigOption {
  bhk: number;
  plus?: boolean;
  label: string;
}

/** Shared BHK/Studio configuration list — used by the filter sidebar and hero search alike. */
export const CONFIG_OPTIONS: ConfigOption[] = [
  { bhk: 0, label: "1 RK / Studio" },
  { bhk: 1, label: "1 BHK" },
  { bhk: 2, label: "2 BHK" },
  { bhk: 3, label: "3 BHK" },
  { bhk: 4, label: "4 BHK" },
  { bhk: 5, plus: true, label: "4+ BHK" },
];
