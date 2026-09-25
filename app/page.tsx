import { HeroSearchBar } from "@/components/search/HeroSearchBar";
import { ProjectSection } from "@/components/home/ProjectSection";
import { CityTabsProjects } from "@/components/home/CityTabsProjects";
import { WhyChooseHomebrix } from "@/components/home/WhyChooseHomebrix";
import { BrowsePropertyType } from "@/components/home/BrowsePropertyType";
import { BuilderStrip } from "@/components/home/BuilderStrip";
import { CtaBanner } from "@/components/home/CtaBanner";
import { HomeBlogSection } from "@/components/home/HomeBlogSection";
import { SectionHeading } from "@/components/home/SectionHeading";
import {
  getNewLaunchProjects,
  getReadyToMoveProjects,
  getLaunchCitiesWithProjects,
  getUnderConstructionProjectsByCity,
} from "@/lib/db/queries";
import { jsonLdScript, organizationSchema, websiteSchema } from "@/lib/seo/schema";
import { ArrowUpRight, ShieldCheck, ArrowRight } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import "./home.css";
import "./search-suggestions.css";
import "./hero-polish.css";
import "./hero-inline.css";

export default async function Home() {
  const [newLaunch, readyToMove, cities] = await Promise.all([
    getNewLaunchProjects(4),
    getReadyToMoveProjects(4),
    getLaunchCitiesWithProjects(5),
  ]);

  const underConstructionByCity = await Promise.all(
    cities.map(async (city) => ({
      citySlug: city.slug,
      cityName: city.name,
      projects: await getUnderConstructionProjectsByCity(city.slug, 6),
    }))
  );

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(websiteSchema())} />
      <script type="application/ld+json" dangerouslySetInnerHTML={jsonLdScript(organizationSchema())} />

      <div className="premium-home">
      <section className="home-hero">
        <div className="hero-picture">
          <Image src="/images/hero_bg_v4.png" alt="Luxury apartment living room and balcony overlooking the Mumbai skyline at dusk" fill priority sizes="100vw" className="object-cover" />
        </div>
        <div className="hero-shade" />
        <div className="hero-content">
          <p className="home-eyebrow hero-markets"><span /> MUMBAI · NAVI MUMBAI · THANE</p>
          <h1>Find your home.<br />
          {/* <em>Build your next chapter.</em> */}
          </h1>
          <p className="hero-description">Trusted homes across Mumbai, Navi Mumbai and Thane.</p>
          <div className="hero-inline-search"><HeroSearchBar /></div>
          <a href="#discover" className="hero-explore">Find your next chapter <ArrowUpRight size={18} /></a>
          <div className="hero-assurance"><ShieldCheck size={17} /> Verified projects <span /> Expert guidance <span /> Zero brokerage</div>
        </div>
        <div className="hero-caption"><span>SPACES THAT INSPIRE</span><p>Extraordinary living.<br />Every single day.</p></div>
      </section>
      <div className="home-search mobile-search-only"><HeroSearchBar /></div>

      {/* Featured Properties: New Launch Projects */}
      <div id="discover" className="discovery-section"><ProjectSection
        mobileCarousel
        kicker="FRESH PERSPECTIVES"
        title="New launches worth exploring"
        subtitle="Explore the latest launches and find a space ahead of its time."
        projects={newLaunch}
        viewAllHref="/new-projects-in-mumbai"
        viewAllLabel="View All Projects"
      />

      </div>
      {/* Under Construction Projects Section */}
      <section className="mx-auto max-w-7xl px-4 py-14">
        <SectionHeading
          kicker="BUILDING TOMORROW"
          title="Homes taking shape"
          subtitle="Track real-time construction progress across your favourite cities."
        />
        <CityTabsProjects data={underConstructionByCity} />
      </section>

      {/* Ready to Move Section */}
      <ProjectSection
        kicker="READY TO MOVE IN"
        title="Ready to move. Ready for you."
        subtitle="Discover ready-to-move homes and start imagining life from day one."
        projects={readyToMove}
        viewAllHref="/ready-to-move-in-mumbai"
        viewAllLabel="View All Projects"
      />

      {/* Homebrix difference */}
      <WhyChooseHomebrix />

      {/* Builder Strip */}
      <div className="home-alternate home-partners"><BuilderStrip /></div>

      {/* Lifestyle collections */}
      <BrowsePropertyType />

      {/* Call to action footer banner */}
      <section className="home-tools">
        <div><p className="home-eyebrow">A LITTLE CLARITY GOES A LONG WAY</p><h2>Big decisions.<br /><em>Made a little easier.</em></h2></div>
        <div className="tool-links">{[{title:"Plan your monthly EMI",desc:"Find a payment that fits your life.",href:"/emi-calculator"},{title:"Discover your buying power",desc:"Make room for the home you want.",href:"/affordability-calculator"},{title:"Compare your favourites",desc:"See what makes each home special.",href:"/compare"}].map(item=><Link href={item.href} key={item.href}><div><h3>{item.title}</h3><p>{item.desc}</p></div><ArrowRight size={20}/></Link>)}</div>
      </section>
      <HomeBlogSection />
      <CtaBanner />
      </div>
    </>
  );
}
