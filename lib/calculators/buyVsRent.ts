import { calculateEmi } from "@/lib/calculators/emi";

export interface BuyVsRentInputs {
  propertyPrice: number;
  downPaymentPct: number;
  interestRate: number;
  loanTenureYears: number;
  monthlyRent: number;
  rentEscalationPct: number;
  propertyAppreciationPct: number;
  investmentReturnPct: number;
  years: number;
}

export interface BuyVsRentYear {
  year: number;
  netCostBuying: number;
  netCostRenting: number;
}

/**
 * Simplified estimate: compares cash outflow net of the asset value created
 * (property appreciation for buying, invested opportunity cost for renting).
 * Not financial advice — a rough planning aid.
 */
export function calculateBuyVsRent(inputs: BuyVsRentInputs): BuyVsRentYear[] {
  const {
    propertyPrice,
    downPaymentPct,
    interestRate,
    loanTenureYears,
    monthlyRent,
    rentEscalationPct,
    propertyAppreciationPct,
    investmentReturnPct,
    years,
  } = inputs;

  const downPayment = (propertyPrice * downPaymentPct) / 100;
  const stampDuty = propertyPrice * 0.06;
  const loanAmount = propertyPrice - downPayment;
  const emi = calculateEmi(loanAmount, interestRate, loanTenureYears);
  const upfrontCash = downPayment + stampDuty;

  const results: BuyVsRentYear[] = [];
  let cumulativeEmi = 0;
  let cumulativeRent = 0;
  let investmentValue = upfrontCash;
  let currentRent = monthlyRent;

  for (let year = 1; year <= years; year++) {
    const emiThisYear = year <= loanTenureYears ? emi * 12 : 0;
    cumulativeEmi += emiThisYear;
    const rentThisYear = currentRent * 12;
    cumulativeRent += rentThisYear;

    const annualSavingsIfRenting = Math.max(0, emiThisYear - rentThisYear);
    investmentValue = investmentValue * (1 + investmentReturnPct / 100) + annualSavingsIfRenting;

    const propertyValue = propertyPrice * Math.pow(1 + propertyAppreciationPct / 100, year);
    const netCostBuying = upfrontCash + cumulativeEmi - propertyValue;
    const netCostRenting = cumulativeRent - investmentValue;

    results.push({ year, netCostBuying: Math.round(netCostBuying), netCostRenting: Math.round(netCostRenting) });
    currentRent *= 1 + rentEscalationPct / 100;
  }

  return results;
}
