import Link from "next/link";
import Image from "next/image";
import { ArrowUpRight, ShieldCheck, UserCheck, Tag, Headset } from "lucide-react";
const FEATURES = [
  { icon: ShieldCheck, title: "Verified project information" },
  { icon: UserCheck, title: "People who know property" },
  { icon: Tag, title: "Transparent pricing" },
  { icon: Headset, title: "Support at every step" },
];
export function WhyChooseHomebrix() {
  return <section className="home-story"><div className="story-inner">
    <div className="story-image"><Image src="/images/why_choose_bg.png" alt="A thoughtfully designed living space with a comfortable armchair" fill sizes="(min-width: 768px) 50vw, 100vw"/><div className="story-note"><ShieldCheck size={28} strokeWidth={1.3}/> A little guidance. A lot of confidence.</div></div>
    <div className="story-copy"><p className="home-eyebrow">THE HOMEBRIX DIFFERENCE</p><h2>A home is personal.<br/><em>So is our approach.</em></h2><p>It’s more than square feet and a pin on a map. It’s where your life happens. We bring local knowledge, clear information, and a human touch to help you find your place.</p><div className="story-features">{FEATURES.map(({icon: Icon,title})=><div key={title}><Icon size={19} strokeWidth={1.4}/><span>{title}</span></div>)}</div><Link href="/about-us">Get to know Homebrix <ArrowUpRight size={17}/></Link></div>
  </div></section>;
}
