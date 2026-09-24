import Link from "next/link";
import Image from "next/image";
import { ArrowUpRight } from "lucide-react";
import { SectionHeading } from "./SectionHeading";
const COLLECTIONS = [
  { title: "The city life", tag: "CONNECTED. CONTEMPORARY. YOURS.", description: "Find your place in Mumbai.", image: "/images/hero_bg.png", href: "/new-projects-in-mumbai" },
  { title: "Room to grow", tag: "A FRESH PERSPECTIVE", description: "Explore homes in Thane.", image: "/images/why_choose_bg.png", href: "/new-projects-in-thane" },
  { title: "Move right in", tag: "LESS WAITING. MORE LIVING.", description: "Homes ready for your next chapter.", image: "/images/cta_banner_bg.png", href: "/ready-to-move-in-mumbai" },
];
export function BrowsePropertyType() {
  return <section className="property-collections"><SectionHeading kicker="FIND YOUR KIND OF LIVING" title="Different dreams. A place for each." subtitle="Start with the life you want to live. Find the home to match."/><div className="collection-grid">{COLLECTIONS.map(item=><Link key={item.title} href={item.href} className="collection-card"><Image src={item.image} alt={item.title} fill sizes="(min-width: 768px) 40vw, 100vw"/><div className="collection-text"><span>{item.tag}</span><h3>{item.title}</h3><p>{item.description}</p><ArrowUpRight size={23}/></div></Link>)}</div></section>;
}
