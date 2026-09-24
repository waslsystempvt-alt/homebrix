import Image from "next/image";
import Link from "next/link";
import { CtaButton } from "@/components/cta/CtaButton";
import { ArrowUpRight, Phone } from "lucide-react";

export function CtaBanner() {
  return <section className="home-advisory"><div className="advisory-panel">
    <Image src="/images/cta_banner_bg.png" alt="An inviting terrace overlooking the city at dusk" fill sizes="(min-width: 1280px) 1216px, 100vw" className="object-cover"/>
    <div className="advisory-shade"/>
    <div className="advisory-content"><p className="home-eyebrow">YOUR NEXT CHAPTER STARTS WITH A CONVERSATION</p><h2>Let’s find a place<br/><em>you’ll love coming home to.</em></h2><p>Tell us what matters to you. Our property advisors will help you take the next step with confidence.</p><div className="advisory-actions"><CtaButton ctaName="Talk to an Expert" leadType="contact_form" className="h-12 rounded-full bg-[#ff474c] px-6 text-white hover:bg-[#ed343a]"><Phone size={15}/> Talk to an expert <ArrowUpRight size={16}/></CtaButton><Link href="/contact-us">Get in touch <ArrowUpRight size={16}/></Link></div><span className="advisory-footnote">Personal guidance. No pressure. Just possibilities.</span></div>
  </div></section>;
}
