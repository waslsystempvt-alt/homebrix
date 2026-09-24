export function calculateEmi(principal: number, annualRatePct: number, years: number): number {
  const monthlyRate = annualRatePct / 12 / 100;
  const months = years * 12;
  if (monthlyRate === 0) return principal / months;
  const factor = Math.pow(1 + monthlyRate, months);
  return (principal * monthlyRate * factor) / (factor - 1);
}

/** Reverse of calculateEmi: given a max affordable EMI, what loan principal does it support? */
export function maxLoanFromEmi(emi: number, annualRatePct: number, years: number): number {
  const monthlyRate = annualRatePct / 12 / 100;
  const months = years * 12;
  if (monthlyRate === 0) return emi * months;
  const factor = Math.pow(1 + monthlyRate, months);
  return (emi * (factor - 1)) / (monthlyRate * factor);
}

export interface AmortizationYear {
  year: number;
  principalPaid: number;
  interestPaid: number;
  balance: number;
}

export function buildAmortizationSchedule(
  principal: number,
  annualRatePct: number,
  years: number
): AmortizationYear[] {
  const monthlyRate = annualRatePct / 12 / 100;
  const emi = calculateEmi(principal, annualRatePct, years);
  let balance = principal;
  const schedule: AmortizationYear[] = [];

  for (let year = 1; year <= years; year++) {
    let principalPaid = 0;
    let interestPaid = 0;
    for (let m = 0; m < 12 && balance > 0; m++) {
      const interest = balance * monthlyRate;
      const principalComponent = Math.min(emi - interest, balance);
      balance -= principalComponent;
      principalPaid += principalComponent;
      interestPaid += interest;
    }
    schedule.push({ year, principalPaid, interestPaid, balance: Math.max(0, balance) });
  }

  return schedule;
}
