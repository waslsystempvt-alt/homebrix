import Link from "next/link";
import Image from "next/image";
import { CtaButton } from "@/components/cta/CtaButton";
import { formatArea, formatPriceRange, STATUS_LABELS } from "@/lib/utils/format";
import { BedDouble, MapPin, Maximize, ShieldCheck } from "lucide-react";
import type { ProjectCardData } from "@/lib/db/queries";
import { CompareButton } from "@/components/project/CompareButton";
import { getExteriorPhoto } from "@/lib/media/stockPhotos";
import { WhatsAppIcon } from "@/components/icons/WhatsAppIcon";
import styles from "./ProjectCard.module.css";

function bhkRangeLabel(configs: { bhk: number }[]): string | null {
  if (!configs.length) return null;
  const values = configs.map(({ bhk }) => bhk).sort((a, b) => a - b);
  const label = (value: number) => value === 0 ? "Studio" : `${value} BHK`;
  return values[0] === values[values.length - 1] ? label(values[0]) : `${values[0] === 0 ? "Studio" : values[0]} – ${values[values.length - 1]} BHK`;
}

export function ProjectCard({ project }: { project: ProjectCardData }) {
  const bhk = bhkRangeLabel(project.configs);
  const area = formatArea(project.areaMinSqft, project.areaMaxSqft);
  const status = String(project.constructionStatus).toLowerCase();
  const ready = status === "ready_to_move";
  return (
    <article className={styles.card}>
      <div className={styles.image}>
        <Image src={getExteriorPhoto(project.id)} alt={`${project.name} exterior`} fill sizes="(min-width: 1024px) 320px, (min-width: 640px) 45vw, 90vw" className={styles.photo}/>
        <Link href={`/projects/${project.city.slug}/${project.slug}`} className={styles.imageLink} aria-label={`View ${project.name}`} tabIndex={-1}/>
        <span className={`${styles.status} ${ready ? styles.ready : ""}`}><span/>{STATUS_LABELS[status] ?? "Explore project"}</span>
        <div className={styles.compare}><CompareButton project={project}/></div>
      </div>
      <div className={styles.body}>
        <div className={styles.cardMeta}><span className={styles.builder}>By {project.builder.name}</span>{project.reraVerified && <span className={styles.verified}><ShieldCheck size={13}/> RERA verified</span>}</div>
        <div>
          <h3 className={styles.title}><Link href={`/projects/${project.city.slug}/${project.slug}`} className={styles.projectLink}>{project.name}</Link></h3>
        </div>
        <p className={styles.location}><MapPin size={13}/><span>{[project.locality?.name, project.city.name].filter(Boolean).join(", ")}</span></p>
        <div className={styles.specs}>
          <span><BedDouble size={15}/>{bhk ?? "On request"}</span>
          <span><Maximize size={14}/>{area || "On request"}</span>
        </div>
        <div className={styles.priceBlock}><span>Price range</span><p className={styles.price}>{formatPriceRange(project.priceMin, project.priceMax)}</p></div>
        <div className={styles.actions}>
          <CtaButton ctaName="Get Best Price" leadType="contact_form" project={{ id: project.id, name: project.name, builderId: project.builderId }} className={styles.enquire}>Get best price</CtaButton>
          <a href={`https://wa.me/919999999999?text=${encodeURIComponent(`Hi, I'm interested in ${project.name}`)}`} target="_blank" rel="noopener noreferrer" className={styles.whatsapp} title="Enquire on WhatsApp" aria-label={`Enquire about ${project.name} on WhatsApp`}><WhatsAppIcon className="size-5"/></a>
        </div>
      </div>
    </article>
  );
}
