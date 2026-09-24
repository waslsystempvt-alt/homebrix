import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getAllStates, getStateBySlug } from "@/lib/db/queries";
import { StampDutyCalculatorClient } from "@/components/calculators/StampDutyCalculatorClient";

interface StampDutyJson {
  stampDutyPct: number;
  registrationPct: number;
}

function isStampDutyJson(value: unknown): value is StampDutyJson {
  return typeof value === "object" && value !== null && "stampDutyPct" in value;
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ state: string }>;
}): Promise<Metadata> {
  const { state: slug } = await params;
  const state = await getStateBySlug(slug);
  if (!state) return {};
  return {
    title: `${state.name} Stamp Duty Calculator | Homebrix`,
    description: `Calculate stamp duty and registration charges for property purchase in ${state.name}.`,
  };
}

export default async function StampDutyCalculatorPage({
  params,
}: {
  params: Promise<{ state: string }>;
}) {
  const { state: slug } = await params;
  const [state, allStates] = await Promise.all([getStateBySlug(slug), getAllStates()]);
  if (!state || !isStampDutyJson(state.stampDuty)) notFound();
  const stampDuty: StampDutyJson = state.stampDuty;

  return (
    <div className="mx-auto max-w-2xl px-4 py-12">
      <h1 className="text-3xl font-bold mb-2">Stamp Duty Calculator — {state.name}</h1>
      <p className="text-muted-foreground mb-8">
        Estimate stamp duty and registration charges for property purchase in {state.name}
      </p>
      <StampDutyCalculatorClient
        currentState={{ slug: state.slug, name: state.name, stampDutyPct: stampDuty.stampDutyPct, registrationPct: stampDuty.registrationPct }}
        allStates={allStates
          .filter((s) => isStampDutyJson(s.stampDuty))
          .map((s) => ({ slug: s.slug, name: s.name }))}
      />
    </div>
  );
}
