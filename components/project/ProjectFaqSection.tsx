import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { HelpCircle } from "lucide-react";
import { formatArea, formatPossession, STATUS_LABELS } from "@/lib/utils/format";
import { faqPageSchema, jsonLdScript } from "@/lib/seo/schema";

export interface FaqEntry {
  question: string;
  answer: string;
}

/** Factual FAQs computed straight from the project's own data — always accurate, no CMS entry required. */
function buildComputedFaqs(
  project: {
    name: string;
    reraNumber: string | null;
    constructionStatus: string;
    possessionDate: Date | null;
    areaMinSqft: number | null;
    areaMaxSqft: number | null;
  },
  cityName: string,
  localityName: string | null
): FaqEntry[] {
  const locationLabel = localityName ? `${localityName}, ${cityName}` : cityName;
  const faqs: FaqEntry[] = [
    {
      question: `Where is ${project.name} located?`,
      answer: `${project.name} is located in ${locationLabel}.`,
    },
  ];

  if (project.reraNumber) {
    faqs.push({
      question: `What is the RERA Number of ${project.name}?`,
      answer: `${project.name} is registered under RERA number ${project.reraNumber}.`,
    });
  }

  const area = formatArea(project.areaMinSqft, project.areaMaxSqft);
  if (area) {
    faqs.push({
      question: `What is the carpet area of homes at ${project.name}?`,
      answer: `Homes at ${project.name} range from ${area} in carpet area.`,
    });
  }

  faqs.push({
    question: `Is ${project.name} under construction or ready-to-move?`,
    answer:
      project.constructionStatus === "ready_to_move"
        ? `${project.name} is ready to move in.`
        : `${project.name} is currently ${(STATUS_LABELS[project.constructionStatus] ?? project.constructionStatus).toLowerCase()}, with possession expected around ${formatPossession(project.possessionDate)}.`,
  });

  faqs.push({
    question: "Are home loans available?",
    answer: `Yes, home loans are available for ${project.name} through leading banks and NBFCs. Use the EMI calculator on this page to estimate your monthly instalment.`,
  });

  return faqs;
}

export function ProjectFaqSection({
  project,
  cityName,
  localityName,
  cmsFaqs,
}: {
  project: {
    name: string;
    reraNumber: string | null;
    constructionStatus: string;
    possessionDate: Date | null;
    areaMinSqft: number | null;
    areaMaxSqft: number | null;
  };
  cityName: string;
  localityName: string | null;
  cmsFaqs: FaqEntry[];
}) {
  const faqs = [...cmsFaqs, ...buildComputedFaqs(project, cityName, localityName)];
  if (faqs.length === 0) return null;

  return (
    <section className="space-y-1">
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(faqPageSchema(faqs))} />
      <div className="flex items-center gap-2">
        <HelpCircle className="size-5 text-primary" />
        <h2 className="text-xl font-bold">Frequently Asked Questions</h2>
      </div>
      <p className="text-sm text-muted-foreground mb-2">Everything you need to know, all in one place</p>
      <Accordion type="single" collapsible className="rounded-2xl border bg-card px-5 shadow-sm">
        {faqs.map((faq, i) => (
          <AccordionItem key={i} value={`faq-${i}`}>
            <AccordionTrigger>{faq.question}</AccordionTrigger>
            <AccordionContent>{faq.answer}</AccordionContent>
          </AccordionItem>
        ))}
      </Accordion>
    </section>
  );
}
