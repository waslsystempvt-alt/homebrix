/**
 * Curated, verified Unsplash photo IDs used as realistic placeholder imagery
 * until real project photography is uploaded via the CMS. Unsplash License
 * permits free commercial and non-commercial use with no attribution required
 * (https://unsplash.com/license). Every ID here has been manually checked to
 * resolve and to actually depict what its category claims.
 */

const EXTERIOR_IDS = [
  "1512917774080-9991f1c4c750",
  "1600585154340-be6161a56a0c",
  "1580587771525-78b9dba3b914",
  "1567684014761-b65e2e59b9eb",
  "1494526585095-c41746248156",
  "1523217582562-09d0def993a6",
  "1600596542815-ffad4c1539a9",
];

const INTERIOR_IDS: Record<"living_room" | "kitchen" | "bedroom" | "bathroom", string[]> = {
  living_room: ["1493809842364-78817add7ffb", "1502672260266-1c1ef2d93688", "1600607687939-ce8a6c25118c"],
  kitchen: ["1556909212-d5b604d0c90d"],
  bedroom: ["1522771739844-6a9f6d5f14af"],
  bathroom: ["1552321554-5fefe8c9ef14"],
};

const HERO_BANNER_ID = "1580041065738-e72023775cdc";

function photoUrl(id: string, width: number): string {
  return `https://images.unsplash.com/photo-${id}?w=${width}&q=75&auto=format&fit=crop`;
}

/** Simple deterministic hash so the same project always shows the same photo. */
function hashSeed(seed: string): number {
  let hash = 0;
  for (let i = 0; i < seed.length; i++) {
    hash = (hash * 31 + seed.charCodeAt(i)) >>> 0;
  }
  return hash;
}

export function getHeroBannerPhoto(width = 1600): string {
  return photoUrl(HERO_BANNER_ID, width);
}

export function getExteriorPhoto(seed: string, width = 600): string {
  const index = hashSeed(seed) % EXTERIOR_IDS.length;
  return photoUrl(EXTERIOR_IDS[index], width);
}

/** Cover photo for a blog post that has no CMS-uploaded thumbnailUrl. */
export function getBlogThumbnail(seed: string, width = 800): string {
  const index = hashSeed(seed) % EXTERIOR_IDS.length;
  return photoUrl(EXTERIOR_IDS[index], width);
}

export function getGalleryPhotos(seed: string, width = 1200): string[] {
  const hash = hashSeed(seed);
  const exterior = EXTERIOR_IDS[hash % EXTERIOR_IDS.length];
  const rooms: (keyof typeof INTERIOR_IDS)[] = ["living_room", "kitchen", "bedroom", "bathroom"];
  const interiors = rooms.map((room, i) => {
    const ids = INTERIOR_IDS[room];
    return ids[(hash + i) % ids.length];
  });
  return [exterior, ...interiors].map((id) => photoUrl(id, width));
}
