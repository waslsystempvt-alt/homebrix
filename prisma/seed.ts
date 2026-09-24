import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../generated/prisma/client";
import { LAUNCH_CITY_SLUGS } from "../lib/config/launchCities";

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });

const STATES: { name: string; slug: string; stampDuty: { stampDutyPct: number; registrationPct: number } }[] = [
  { name: "Maharashtra", slug: "maharashtra", stampDuty: { stampDutyPct: 6, registrationPct: 1 } },
  { name: "Karnataka", slug: "karnataka", stampDuty: { stampDutyPct: 5, registrationPct: 1 } },
  { name: "Telangana", slug: "telangana", stampDuty: { stampDutyPct: 5.5, registrationPct: 0.5 } },
  { name: "Tamil Nadu", slug: "tamil-nadu", stampDuty: { stampDutyPct: 7, registrationPct: 1 } },
  { name: "Delhi", slug: "delhi", stampDuty: { stampDutyPct: 6, registrationPct: 1 } },
  { name: "Haryana", slug: "haryana", stampDuty: { stampDutyPct: 7, registrationPct: 1 } },
  { name: "Uttar Pradesh", slug: "uttar-pradesh", stampDuty: { stampDutyPct: 7, registrationPct: 1 } },
  { name: "West Bengal", slug: "west-bengal", stampDuty: { stampDutyPct: 6, registrationPct: 1 } },
  { name: "Gujarat", slug: "gujarat", stampDuty: { stampDutyPct: 4.9, registrationPct: 1 } },
];

interface LocalitySeed {
  name: string;
  slug: string;
  avgPriceSqft: number;
  isPopular?: boolean;
  /** Region name — must match a key in that city's `regions` list. Omit for localities with no region grouping yet. */
  region?: string;
}

const CITIES: {
  name: string;
  slug: string;
  state: string;
  isMetro: boolean;
  regions?: { name: string; slug: string }[];
  localities: LocalitySeed[];
}[] = [
  {
    name: "Mumbai",
    slug: "mumbai",
    state: "maharashtra",
    isMetro: true,
    regions: [
      { name: "Western Mumbai", slug: "western-mumbai" },
      { name: "Harbour", slug: "harbour" },
      { name: "South Mumbai", slug: "south-mumbai" },
      { name: "Central Mumbai", slug: "central-mumbai" },
    ],
    localities: [
      { name: "Andheri West", slug: "andheri-west", avgPriceSqft: 24500, isPopular: true, region: "Western Mumbai" },
      { name: "Borivali", slug: "borivali", avgPriceSqft: 19500, isPopular: true, region: "Western Mumbai" },
      { name: "Goregaon", slug: "goregaon", avgPriceSqft: 20200, region: "Western Mumbai" },
      { name: "Kandivali", slug: "kandivali", avgPriceSqft: 18800, region: "Western Mumbai" },
      { name: "Malad", slug: "malad", avgPriceSqft: 18200, region: "Western Mumbai" },
      { name: "Jogeshwari", slug: "jogeshwari", avgPriceSqft: 19800, region: "Western Mumbai" },
      { name: "Vile Parle", slug: "vile-parle", avgPriceSqft: 27500, region: "Western Mumbai" },
      { name: "Santacruz", slug: "santacruz", avgPriceSqft: 28900, region: "Western Mumbai" },
      { name: "Bandra", slug: "bandra", avgPriceSqft: 42000, isPopular: true, region: "Western Mumbai" },
      { name: "Dahisar", slug: "dahisar", avgPriceSqft: 16800, region: "Western Mumbai" },
      { name: "Mira Road", slug: "mira-road", avgPriceSqft: 12800, region: "Western Mumbai" },

      { name: "Powai", slug: "powai", avgPriceSqft: 21800, isPopular: true, region: "Harbour" },
      { name: "Chembur", slug: "chembur", avgPriceSqft: 19200, isPopular: true, region: "Harbour" },
      { name: "Mulund", slug: "mulund", avgPriceSqft: 20500, region: "Harbour" },
      { name: "Vikhroli", slug: "vikhroli", avgPriceSqft: 19600, region: "Harbour" },
      { name: "Ghatkopar", slug: "ghatkopar", avgPriceSqft: 21200, region: "Harbour" },
      { name: "Kanjurmarg", slug: "kanjurmarg", avgPriceSqft: 18900, region: "Harbour" },
      { name: "Bhandup", slug: "bhandup", avgPriceSqft: 17400, region: "Harbour" },

      { name: "Worli", slug: "worli", avgPriceSqft: 55000, isPopular: true, region: "South Mumbai" },
      { name: "Mahalaxmi", slug: "mahalaxmi", avgPriceSqft: 48000, region: "South Mumbai" },
      { name: "Byculla", slug: "byculla", avgPriceSqft: 32000, region: "South Mumbai" },
      { name: "Sewri", slug: "sewri", avgPriceSqft: 29500, region: "South Mumbai" },
      { name: "Parel", slug: "parel", avgPriceSqft: 38000, region: "South Mumbai" },
      { name: "Dadar", slug: "dadar", avgPriceSqft: 40500, region: "South Mumbai" },
      { name: "Lalbaug", slug: "lalbaug", avgPriceSqft: 34000, region: "South Mumbai" },
      { name: "Lower Parel", slug: "lower-parel", avgPriceSqft: 45000, isPopular: true, region: "South Mumbai" },
      { name: "Prabhadevi", slug: "prabhadevi", avgPriceSqft: 52000, region: "South Mumbai" },
      { name: "Mahim", slug: "mahim", avgPriceSqft: 39500, region: "South Mumbai" },

      { name: "Sion", slug: "sion", avgPriceSqft: 26500, region: "Central Mumbai" },
      { name: "Wadala", slug: "wadala", avgPriceSqft: 27800, region: "Central Mumbai" },
      { name: "Matunga", slug: "matunga", avgPriceSqft: 33500, region: "Central Mumbai" },
    ],
  },
  {
    name: "Thane",
    slug: "thane",
    state: "maharashtra",
    isMetro: true,
    regions: [
      { name: "Majiwada–Kolshet Corridor", slug: "majiwada-kolshet-corridor" },
      { name: "Ghodbunder Extension", slug: "ghodbunder-extension" },
      { name: "Hiranandani–Manpada Zone", slug: "hiranandani-manpada-zone" },
    ],
    localities: [
      { name: "Ghodbunder Road", slug: "ghodbunder-road", avgPriceSqft: 13800, isPopular: true, region: "Ghodbunder Extension" },
      { name: "Kasarvadavali", slug: "kasarvadavali", avgPriceSqft: 12200, region: "Ghodbunder Extension" },
      { name: "Balkum", slug: "balkum", avgPriceSqft: 12800, region: "Ghodbunder Extension" },

      { name: "Majiwada", slug: "majiwada", avgPriceSqft: 14500, isPopular: true, region: "Majiwada–Kolshet Corridor" },
      { name: "Kolshet", slug: "kolshet", avgPriceSqft: 13900, region: "Majiwada–Kolshet Corridor" },
      { name: "Pokhran 1", slug: "pokhran-1", avgPriceSqft: 15200, region: "Majiwada–Kolshet Corridor" },
      { name: "Pokhran 2", slug: "pokhran-2", avgPriceSqft: 14800, region: "Majiwada–Kolshet Corridor" },

      { name: "Manpada", slug: "manpada", avgPriceSqft: 15600, isPopular: true, region: "Hiranandani–Manpada Zone" },
      { name: "Bhayandarpada", slug: "bhayandarpada", avgPriceSqft: 13200, region: "Hiranandani–Manpada Zone" },
      { name: "Waghbil", slug: "waghbil", avgPriceSqft: 12600, region: "Hiranandani–Manpada Zone" },

      { name: "Dombivli", slug: "dombivli", avgPriceSqft: 9800, isPopular: true },
      { name: "Kalyan", slug: "kalyan", avgPriceSqft: 8600 },
      { name: "Shilphata", slug: "shilphata", avgPriceSqft: 8200, isPopular: true },
    ],
  },
  {
    name: "Pune",
    slug: "pune",
    state: "maharashtra",
    isMetro: true,
    localities: [
      { name: "Hinjewadi", slug: "hinjewadi", avgPriceSqft: 8200, isPopular: true },
      { name: "Undri", slug: "undri", avgPriceSqft: 6900 },
      { name: "Wagholi", slug: "wagholi", avgPriceSqft: 6100 },
    ],
  },
  {
    name: "Bangalore",
    slug: "bangalore",
    state: "karnataka",
    isMetro: true,
    localities: [
      { name: "Whitefield", slug: "whitefield", avgPriceSqft: 9800, isPopular: true },
      { name: "Sarjapur Road", slug: "sarjapur-road", avgPriceSqft: 8600, isPopular: true },
      { name: "Electronic City", slug: "electronic-city", avgPriceSqft: 6900 },
    ],
  },
  {
    name: "Hyderabad",
    slug: "hyderabad",
    state: "telangana",
    isMetro: true,
    localities: [
      { name: "Gachibowli", slug: "gachibowli", avgPriceSqft: 8900, isPopular: true },
      { name: "Kokapet", slug: "kokapet", avgPriceSqft: 9600 },
    ],
  },
  {
    name: "Chennai",
    slug: "chennai",
    state: "tamil-nadu",
    isMetro: true,
    localities: [
      { name: "OMR", slug: "omr", avgPriceSqft: 7200, isPopular: true },
      { name: "Porur", slug: "porur", avgPriceSqft: 6800 },
    ],
  },
  {
    name: "Delhi",
    slug: "delhi",
    state: "delhi",
    isMetro: true,
    localities: [{ name: "Dwarka", slug: "dwarka", avgPriceSqft: 12500, isPopular: true }],
  },
  {
    name: "Noida",
    slug: "noida",
    state: "uttar-pradesh",
    isMetro: true,
    localities: [
      { name: "Sector 150", slug: "sector-150", avgPriceSqft: 9800, isPopular: true },
      { name: "Noida Extension", slug: "noida-extension", avgPriceSqft: 6200 },
    ],
  },
  {
    name: "Gurgaon",
    slug: "gurgaon",
    state: "haryana",
    isMetro: true,
    localities: [
      { name: "Sector 63", slug: "sector-63", avgPriceSqft: 14200, isPopular: true },
      { name: "Sector 57", slug: "sector-57", avgPriceSqft: 15800 },
      { name: "Dwarka Expressway", slug: "dwarka-expressway", avgPriceSqft: 9600, isPopular: true },
    ],
  },
  {
    name: "Kolkata",
    slug: "kolkata",
    state: "west-bengal",
    isMetro: true,
    localities: [{ name: "New Town", slug: "new-town", avgPriceSqft: 7600, isPopular: true }],
  },
  {
    name: "Ahmedabad",
    slug: "ahmedabad",
    state: "gujarat",
    isMetro: true,
    localities: [{ name: "SG Highway", slug: "sg-highway", avgPriceSqft: 6800, isPopular: true }],
  },
  {
    name: "Navi Mumbai",
    slug: "navi-mumbai",
    state: "maharashtra",
    isMetro: true,
    regions: [
      { name: "Palm Beach", slug: "palm-beach" },
      { name: "Kharghar", slug: "kharghar" },
      { name: "Digha-Turbhe", slug: "digha-turbhe" },
      { name: "Panvel", slug: "panvel" },
    ],
    localities: [
      { name: "Vashi", slug: "vashi", avgPriceSqft: 16500, isPopular: true, region: "Palm Beach" },
      { name: "Sanpada", slug: "sanpada", avgPriceSqft: 15800, region: "Palm Beach" },
      { name: "Nerul", slug: "nerul", avgPriceSqft: 15200, isPopular: true, region: "Palm Beach" },
      { name: "Belapur", slug: "belapur", avgPriceSqft: 14800, isPopular: true, region: "Palm Beach" },
      { name: "Palm Beach Road", slug: "palm-beach-road", avgPriceSqft: 18900, isPopular: true, region: "Palm Beach" },

      { name: "Kharghar", slug: "kharghar", avgPriceSqft: 11800, isPopular: true, region: "Kharghar" },
      { name: "Taloja", slug: "taloja", avgPriceSqft: 7200, region: "Kharghar" },
      { name: "Upper Kharghar", slug: "upper-kharghar", avgPriceSqft: 10500, region: "Kharghar" },

      { name: "Airoli", slug: "airoli", avgPriceSqft: 13600, isPopular: true, region: "Digha-Turbhe" },
      { name: "Ghansoli", slug: "ghansoli", avgPriceSqft: 12400, isPopular: true, region: "Digha-Turbhe" },
      { name: "Digha", slug: "digha", avgPriceSqft: 9800, region: "Digha-Turbhe" },
      { name: "Rasayani", slug: "rasayani", avgPriceSqft: 5400, region: "Digha-Turbhe" },

      { name: "Panvel", slug: "panvel", avgPriceSqft: 8600, isPopular: true, region: "Panvel" },
      { name: "Kalamboli", slug: "kalamboli", avgPriceSqft: 7800, region: "Panvel" },
      { name: "Palaspe", slug: "palaspe", avgPriceSqft: 6900, region: "Panvel" },
      { name: "Shedung", slug: "shedung", avgPriceSqft: 6200, region: "Panvel" },
      { name: "Juinagar", slug: "juinagar", avgPriceSqft: 15400, region: "Panvel" },
    ],
  },
];

const BUILDERS = [
  {
    name: "Lodha Group",
    slug: "lodha-group",
    establishedYear: 1980,
    headquarters: "Mumbai, Maharashtra",
    totalDelivered: 48,
    underConstruction: 12,
    deliveryRatePct: 87.0,
    trustScore: 4.4,
    verified: true,
    featured: true,
    description:
      "One of India's leading real estate developers, known for large-scale integrated townships and luxury residences.",
  },
  {
    name: "Godrej Properties",
    slug: "godrej-properties",
    establishedYear: 1990,
    headquarters: "Mumbai, Maharashtra",
    totalDelivered: 62,
    underConstruction: 18,
    deliveryRatePct: 91.0,
    trustScore: 4.5,
    verified: true,
    featured: true,
  },
  {
    name: "DLF Limited",
    slug: "dlf-limited",
    establishedYear: 1946,
    headquarters: "New Delhi",
    totalDelivered: 154,
    underConstruction: 9,
    deliveryRatePct: 89.0,
    trustScore: 4.3,
    verified: true,
    featured: true,
  },
  {
    name: "Prestige Group",
    slug: "prestige-group",
    establishedYear: 1986,
    headquarters: "Bangalore, Karnataka",
    totalDelivered: 289,
    underConstruction: 24,
    deliveryRatePct: 88.0,
    trustScore: 4.4,
    verified: true,
    featured: true,
  },
  {
    name: "Sobha Limited",
    slug: "sobha-limited",
    establishedYear: 1995,
    headquarters: "Bangalore, Karnataka",
    totalDelivered: 173,
    underConstruction: 15,
    deliveryRatePct: 92.0,
    trustScore: 4.6,
    verified: true,
  },
  {
    name: "Brigade Group",
    slug: "brigade-group",
    establishedYear: 1986,
    headquarters: "Bangalore, Karnataka",
    totalDelivered: 90,
    underConstruction: 11,
    deliveryRatePct: 90.0,
    trustScore: 4.3,
    verified: true,
  },
];

const JOBS: {
  slug: string;
  title: string;
  department: string;
  location: string;
  type: string;
  description: string;
  requirements: string[];
}[] = [
  {
    slug: "sales-manager-navi-mumbai",
    title: "Sales Manager",
    department: "Sales",
    location: "Navi Mumbai",
    type: "Full-time",
    description:
      "Own builder and buyer relationships across our Navi Mumbai launches. You'll run site visits, negotiate with builders on inventory and pricing, and close deals with home buyers sourced through the platform.",
    requirements: [
      "3+ years in real estate sales, ideally new-launch or under-construction projects",
      "Comfortable with day-to-day site visits across Navi Mumbai",
      "Strong follow-up discipline — most deals close on the third or fourth touchpoint",
    ],
  },
  {
    slug: "frontend-engineer-mumbai",
    title: "Frontend Engineer",
    department: "Engineering",
    location: "Mumbai (Hybrid)",
    type: "Full-time",
    description:
      "Work directly on the buyer-facing site — project pages, search, calculators, the lead funnel. We're a small team, so you'll ship end-to-end features, not just components.",
    requirements: [
      "Solid React/Next.js experience, comfortable with TypeScript",
      "Care about performance and SEO — this is a search-driven product",
      "Can work independently with minimal hand-holding",
    ],
  },
  {
    slug: "content-writer-remote",
    title: "Real Estate Content Writer",
    department: "Marketing",
    location: "Remote",
    type: "Full-time",
    description:
      "Write locality guides, project descriptions, and buyer-education articles for Mumbai, Navi Mumbai and Thane. You'll work closely with the SEO and sales teams to know what buyers are actually asking.",
    requirements: [
      "Excellent written English, comfortable with real estate/finance terminology",
      "Some SEO writing experience preferred",
      "Based in India, familiar with the Mumbai/Navi Mumbai/Thane property market",
    ],
  },
  {
    slug: "customer-success-thane",
    title: "Customer Success Associate",
    department: "Operations",
    location: "Thane",
    type: "Full-time",
    description:
      "First point of contact for buyers reaching out through the site — qualify leads, schedule site visits, and coordinate between buyers and builder sales teams until a visit happens.",
    requirements: [
      "Fluent in Hindi, Marathi and English",
      "Comfortable on the phone all day — this is a high-volume, high-follow-up role",
      "Prior experience in real estate, BPO, or telesales is a plus",
    ],
  },
];

const BLOG_POSTS: {
  title: string;
  slug: string;
  category: string;
  excerpt: string;
  tags: string[];
  readingTime: number;
  blocks: { type: "heading" | "paragraph"; text: string }[];
}[] = [
  {
    title: "RERA Explained: What Every Home Buyer Must Check Before Booking",
    slug: "rera-explained-what-to-check-before-booking",
    category: "Legal & RERA",
    excerpt: "RERA registration protects buyers from delays and fraud. Here's exactly what to verify before you pay a booking amount.",
    tags: ["RERA", "buying-guide", "legal"],
    readingTime: 6,
    blocks: [
      { type: "heading", text: "Why RERA Matters" },
      { type: "paragraph", text: "The Real Estate (Regulation and Development) Act, 2016 requires every project above 500 sqm or 8 units to be registered with the state RERA authority before it can be marketed or sold. Registration forces builders to disclose project timelines, land title, and approvals publicly." },
      { type: "heading", text: "What to Verify" },
      { type: "paragraph", text: "Always cross-check the RERA number on the state RERA portal — not just the number the builder shows you. Confirm the promised possession date matches what's listed on the portal, and check for any past complaints against the project or builder." },
      { type: "paragraph", text: "If a project isn't RERA-registered and it should be, that's a serious red flag. Walk away or demand registration before booking." },
    ],
  },
  {
    title: "Under Construction vs Ready to Move: Which Should You Buy?",
    slug: "under-construction-vs-ready-to-move",
    category: "Buying Guide",
    excerpt: "Under-construction homes are cheaper but riskier. Ready-to-move properties cost more but remove uncertainty. Here's how to decide.",
    tags: ["buying-guide", "under-construction"],
    readingTime: 5,
    blocks: [
      { type: "heading", text: "The Price Gap" },
      { type: "paragraph", text: "Under-construction projects are typically priced 10-20% lower than comparable ready-to-move properties, since buyers absorb construction and delivery risk in exchange for the discount." },
      { type: "heading", text: "GST Matters" },
      { type: "paragraph", text: "Under-construction homes attract GST (typically 1% for affordable housing, 5% for others), while ready-to-move properties with a completion certificate are GST-exempt. Factor this into your total cost comparison." },
      { type: "paragraph", text: "If you can verify the builder's track record and the project is RERA-registered with a realistic timeline, under-construction can offer real savings. If certainty matters more than price, ready-to-move removes the guesswork." },
    ],
  },
  {
    title: "Thane Real Estate Market Report — Q2 2026",
    slug: "thane-real-estate-market-report-q2-2026",
    category: "Market Reports",
    excerpt: "Thane's Ghodbunder Road and Dombivli corridors continue to see strong demand. Here's what the numbers show this quarter.",
    tags: ["market-report", "thane"],
    readingTime: 4,
    blocks: [
      { type: "paragraph", text: "Thane's residential market recorded steady price appreciation through Q2 2026, driven by improving metro connectivity and a wave of new launches along the Ghodbunder Road corridor." },
      { type: "heading", text: "Key Numbers" },
      { type: "paragraph", text: "Average price per sqft in Ghodbunder Road rose to approximately ₹13,800, up from ₹12,900 a year earlier. Dombivli remains the more affordable entry point for 2 BHK buyers, averaging ₹9,800/sqft." },
      { type: "paragraph", text: "Builders including Lodha, Godrej, and Prestige have all announced new launches in the corridor, suggesting continued supply growth to match demand." },
    ],
  },
  {
    title: "How Much Home Loan Can You Actually Afford?",
    slug: "how-much-home-loan-can-you-afford",
    category: "Home Loans",
    excerpt: "Banks approve loans based on your income, but that doesn't mean you should borrow the maximum. Here's how to think about it.",
    tags: ["home-loans", "affordability"],
    readingTime: 5,
    blocks: [
      { type: "paragraph", text: "Most lenders use a Fixed Obligation to Income Ratio (FOIR) of 40-50%, meaning your total EMIs — including the new home loan — shouldn't exceed half your monthly income." },
      { type: "heading", text: "Bank Maximum vs Your Comfortable Maximum" },
      { type: "paragraph", text: "Just because a bank approves a ₹80 lakh loan doesn't mean you should take it. Factor in other goals — retirement savings, children's education, emergency funds — before committing to the maximum EMI a bank will offer." },
      { type: "paragraph", text: "Use an eligibility calculator to see the bank's number, then work backward from a monthly payment you're actually comfortable with." },
    ],
  },
  {
    title: "5 Localities in Bangalore Poised for Price Growth in 2026",
    slug: "bangalore-localities-poised-for-growth-2026",
    category: "Investment Tips",
    excerpt: "Infrastructure upgrades and IT expansion are driving demand in specific Bangalore micro-markets. Here's where to look.",
    tags: ["investment", "bangalore", "city-guides"],
    readingTime: 6,
    blocks: [
      { type: "paragraph", text: "Bangalore's growth corridors continue to shift as metro lines extend and IT parks expand beyond the traditional core. Whitefield and Sarjapur Road remain strong, but a few emerging pockets are worth watching." },
      { type: "heading", text: "What's Driving Demand" },
      { type: "paragraph", text: "Upcoming metro connectivity, proximity to IT/ITES campuses, and a healthy pipeline of new project launches from established builders are the three consistent signals across the localities showing the strongest price momentum." },
      { type: "paragraph", text: "As always, verify RERA status and builder track record before treating any locality trend as a guarantee — market forecasts are directional, not certain." },
    ],
  },
];

function slugify(s: string) {
  return s.toLowerCase().replace(/\s+/g, "-").replace(/[^a-z0-9-]/g, "");
}

function buildPaymentPlans(priceMax: bigint) {
  const total = Number(priceMax);
  const stage = (pct: number) => Math.round((total * pct) / 100);
  return {
    construction_linked: [
      { label: "Booking", pct: 10, amount: stage(10), due: "Now" },
      { label: "On Foundation", pct: 15, amount: stage(15), due: "3 months" },
      { label: "On Slab 5", pct: 15, amount: stage(15), due: "9 months" },
      { label: "On Slab 10", pct: 20, amount: stage(20), due: "15 months" },
      { label: "On Possession", pct: 40, amount: stage(40), due: "On possession" },
    ],
    down_payment: [
      { label: "Booking + Down Payment", pct: 90, amount: stage(90), due: "Within 30 days" },
      { label: "On Possession", pct: 10, amount: stage(10), due: "On possession" },
    ],
    flexi: [
      { label: "Booking", pct: 20, amount: stage(20), due: "Now" },
      { label: "During Construction", pct: 50, amount: stage(50), due: "Milestone based" },
      { label: "On Possession", pct: 30, amount: stage(30), due: "On possession" },
    ],
  };
}

function hashSeed(input: string): number {
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    hash = (hash * 31 + input.charCodeAt(i)) >>> 0;
  }
  return hash;
}

type LandmarkCategory = "school" | "hospital" | "mall" | "college_university";

const LANDMARK_BANK: Record<LandmarkCategory, string[]> = {
  school: ["DAV Public School", "Ryan International School", "Podar International School", "Vibgyor High School", "Euro School"],
  hospital: ["Apollo Hospital", "Fortis Hospital", "Criticare Hospital", "Wockhardt Hospital", "Global Hospital"],
  mall: ["City Centre Mall", "Inorbit Mall", "Metro Junction Mall", "R Mall", "Central Plaza"],
  college_university: [
    "St. Xavier's College",
    "D.Y. Patil University",
    "K.J. Somaiya College",
    "NMIMS Campus",
    "Mumbai University Sub-Campus",
  ],
};

const LANDMARK_COUNT_PER_CATEGORY: Record<LandmarkCategory, number> = {
  school: 2,
  hospital: 1,
  mall: 1,
  college_university: 1,
};

/** Deterministic per-project pick from a curated landmark bank — no real address data needed. */
function buildLandmarks(projectId: string) {
  const landmarks: { category: LandmarkCategory; name: string; travelMinutes: number; displayOrder: number }[] = [];
  let order = 0;
  for (const category of Object.keys(LANDMARK_BANK) as LandmarkCategory[]) {
    const bank = LANDMARK_BANK[category];
    for (let i = 0; i < LANDMARK_COUNT_PER_CATEGORY[category]; i++) {
      const h = hashSeed(`${projectId}-${category}-${i}`);
      landmarks.push({
        category,
        name: bank[h % bank.length],
        travelMinutes: 5 + (h % 21),
        displayOrder: order++,
      });
    }
  }
  return landmarks;
}

const AMENITY_LABELS: Record<string, string> = {
  swimming_pool: "a swimming pool",
  gym: "a fully-equipped gym",
  clubhouse: "a clubhouse",
  garden: "a landscaped garden",
  security_247: "24/7 security",
  parking: "dedicated parking",
  power_backup: "power backup",
  play_area: "a children's play area",
};

/** CMS-style FAQ content, templated from the project's own real fields rather than hardcoded per project. */
function buildFaqSeeds(params: {
  name: string;
  cityName: string;
  localityName: string;
  totalTowers: number;
  totalFloors: number;
  amenities: Record<string, boolean>;
}): { question: string; answer: string }[] {
  const { name, cityName, localityName, totalTowers, totalFloors, amenities } = params;
  const amenityList = Object.entries(amenities)
    .filter(([, active]) => active)
    .map(([key]) => AMENITY_LABELS[key])
    .filter(Boolean);

  return [
    {
      question: `What unique architectural feature does ${name} boast in the ${cityName} skyline?`,
      answer: `${name} is designed with ${totalTowers} tower${totalTowers > 1 ? "s" : ""} rising to ${totalFloors} floors, giving it a distinctive silhouette and panoramic views across ${cityName}.`,
    },
    {
      question: `How beneficial is ${name}'s connectivity to the rest of ${cityName}?`,
      answer: `Located in ${localityName}, ${name} offers convenient access to key business districts, railway stations, and arterial roads across ${cityName}, making everyday commutes easier for residents.`,
    },
    {
      question: "What are the key luxury and recreational amenities available to residents?",
      answer:
        amenityList.length > 0
          ? `Residents have access to ${amenityList.join(", ")}, designed for a comfortable, modern lifestyle.`
          : `${name} offers a range of resident amenities designed for a comfortable, modern lifestyle.`,
    },
  ];
}

async function main() {
  console.log("Seeding states...");
  for (const s of STATES) {
    await prisma.state.upsert({ where: { slug: s.slug }, update: { stampDuty: s.stampDuty }, create: s });
  }

  console.log("Seeding cities + regions + localities...");
  for (const c of CITIES) {
    const state = await prisma.state.findUniqueOrThrow({ where: { slug: c.state } });
    const city = await prisma.city.upsert({
      where: { slug: c.slug },
      update: {},
      create: { name: c.name, slug: c.slug, stateId: state.id, isMetro: c.isMetro },
    });

    const regionIdByName = new Map<string, number>();
    for (const r of c.regions ?? []) {
      const region = await prisma.region.upsert({
        where: { cityId_slug: { cityId: city.id, slug: r.slug } },
        update: { name: r.name },
        create: { cityId: city.id, name: r.name, slug: r.slug },
      });
      regionIdByName.set(r.name, region.id);
    }

    for (const l of c.localities) {
      const regionId = l.region ? regionIdByName.get(l.region) : undefined;
      await prisma.locality.upsert({
        where: { cityId_slug: { cityId: city.id, slug: l.slug } },
        update: { avgPriceSqft: l.avgPriceSqft, isPopular: l.isPopular ?? false, regionId },
        create: {
          cityId: city.id,
          regionId,
          name: l.name,
          slug: l.slug,
          avgPriceSqft: l.avgPriceSqft,
          isPopular: l.isPopular ?? false,
        },
      });
    }
  }

  console.log("Seeding builders...");
  for (const b of BUILDERS) {
    await prisma.builder.upsert({ where: { slug: b.slug }, update: {}, create: b });
  }

  console.log("Seeding sample projects...");
  const builders = await prisma.builder.findMany({ orderBy: { slug: "asc" } });
  const citiesWithLocalities = await prisma.city.findMany({
    orderBy: { id: "asc" },
    include: { localities: { orderBy: { id: "asc" } } },
  });

  const statusCycle: ("new_launch" | "under_construction" | "ready_to_move")[] = [
    "new_launch",
    "under_construction",
    "ready_to_move",
  ];

  const projectNames = [
    "Palava City",
    "Greens Enclave",
    "The Arbour",
    "City Heights",
    "Emerald Bay",
    "Skyline Residences",
    "Meadows Phase 2",
    "Horizon Towers",
    "Serenity Park",
    "Urban Vista",
  ];

  let projectIndex = 0;
  for (const city of citiesWithLocalities) {
    if (city.localities.length === 0) continue;

    const projectsForCity = LAUNCH_CITY_SLUGS.includes(city.slug)
      ? Math.max(2, city.localities.length)
      : 2;

    for (let i = 0; i < projectsForCity; i++) {
      const builder = builders[projectIndex % builders.length];
      const locality = city.localities[i % city.localities.length];
      const baseName = projectNames[projectIndex % projectNames.length];
      const name = `${builder.name.split(" ")[0]} ${baseName}`;
      const slug = slugify(`${name}-${locality.name}`);
      const status = statusCycle[projectIndex % statusCycle.length];
      const priceMin = BigInt((4 + (projectIndex % 8)) * 1_000_000);
      const priceMax = priceMin + BigInt((6 + (projectIndex % 10)) * 1_000_000);

      const projectData = {
        name,
        builderId: builder.id,
        cityId: city.id,
        localityId: locality.id,
        address: `${locality.name}, ${city.name}`,
        reraNumber: `P${city.id}${builder.id.slice(0, 6).toUpperCase()}`,
        reraVerified: true,
        priceMin,
        priceMax,
        pricePerSqftMin: (locality.avgPriceSqft ?? 6000) - 500,
        pricePerSqftMax: (locality.avgPriceSqft ?? 6000) + 1500,
        areaMinSqft: 650,
        areaMaxSqft: 1400,
        totalUnits: 200 + projectIndex * 37,
        totalTowers: 2 + (projectIndex % 6),
        totalFloors: 12 + (projectIndex % 20),
        launchDate: new Date(2024, projectIndex % 12, 1),
        possessionDate: new Date(2027, projectIndex % 12, 1),
        constructionPct: status === "ready_to_move" ? 100 : status === "under_construction" ? 45 + (projectIndex % 40) : 5,
        constructionStatus: status,
        projectStatus: "active" as const,
        description: `${name} by ${builder.name} offers modern residences in ${locality.name}, ${city.name} with premium amenities and excellent connectivity.`,
        highlights: ["RERA Registered", "Prime Location", "Modern Amenities"],
        amenities: {
          swimming_pool: true,
          gym: true,
          clubhouse: true,
          security_247: true,
          parking: true,
          power_backup: true,
          garden: true,
          play_area: true,
          lift: true,
          indoor_games: true,
          jogging_track: true,
          yoga_deck: true,
          senior_citizen_area: true,
          rainwater_harvesting: true,
          intercom: true,
          fire_safety: true,
          community_hall: projectIndex % 2 === 0,
          ev_charging: projectIndex % 3 === 0,
        },
        paymentPlans: buildPaymentPlans(priceMax),
        published: true,
        publishedAt: new Date(),
        featured: projectIndex % 4 === 0,
        newLaunchBadge: status === "new_launch",
        reraBadge: true,
      };

      const project = await prisma.project.upsert({
        where: { cityId_slug: { cityId: city.id, slug } },
        update: projectData,
        create: { ...projectData, slug },
      });

      const existingConfigs = await prisma.projectConfig.count({ where: { projectId: project.id } });
      if (existingConfigs === 0) {
        await prisma.projectConfig.createMany({
          data: [
            {
              projectId: project.id,
              bhk: 2,
              bedrooms: 2,
              bathrooms: 2,
              areaCarpetMin: 650,
              areaCarpetMax: 850,
              priceMin,
              priceMax: priceMin + BigInt(2_000_000),
              displayOrder: 0,
            },
            {
              projectId: project.id,
              bhk: 3,
              bedrooms: 3,
              bathrooms: 2,
              areaCarpetMin: 1050,
              areaCarpetMax: 1250,
              priceMin: priceMin + BigInt(2_000_000),
              priceMax,
              displayOrder: 1,
            },
          ],
        });
      }

      const existingUpdates = await prisma.constructionUpdate.count({ where: { projectId: project.id } });
      if (status !== "new_launch" && existingUpdates === 0) {
        const pct = status === "ready_to_move" ? 100 : 45 + (projectIndex % 40);
        const updates = [
          { monthsAgo: 8, completionPct: Math.max(10, pct - 40), title: "Foundation work completed" },
          { monthsAgo: 5, completionPct: Math.max(20, pct - 25), title: "Structural work in progress" },
          { monthsAgo: 2, completionPct: Math.max(30, pct - 10), title: "Brickwork and plastering" },
          { monthsAgo: 0, completionPct: pct, title: "Finishing work underway" },
        ];
        const now = new Date(2026, 7, 1);
        await prisma.constructionUpdate.createMany({
          data: updates.map((u) => ({
            projectId: project.id,
            updateDate: new Date(now.getFullYear(), now.getMonth() - u.monthsAgo, 15),
            title: u.title,
            completionPct: u.completionPct,
          })),
        });
      }

      const existingLandmarks = await prisma.projectLandmark.count({ where: { projectId: project.id } });
      if (existingLandmarks === 0) {
        await prisma.projectLandmark.createMany({ data: buildLandmarks(project.id).map((l) => ({ ...l, projectId: project.id })) });
      }

      const existingFaqs = await prisma.projectFaq.count({ where: { projectId: project.id } });
      if (existingFaqs === 0) {
        const faqSeeds = buildFaqSeeds({
          name,
          cityName: city.name,
          localityName: locality.name,
          totalTowers: projectData.totalTowers,
          totalFloors: projectData.totalFloors,
          amenities: projectData.amenities,
        });
        await prisma.projectFaq.createMany({
          data: faqSeeds.map((f, i) => ({ ...f, projectId: project.id, displayOrder: i })),
        });
      }

      projectIndex++;
    }
  }

  console.log("Seeding blog...");
  const editor = await prisma.user.upsert({
    where: { id: "seed-editor" },
    update: {},
    create: { id: "seed-editor", name: "Homebrix Editorial", role: "cms_editor" },
  });

  for (const post of BLOG_POSTS) {
    await prisma.blogPost.upsert({
      where: { slug: post.slug },
      update: {
        title: post.title,
        category: post.category,
        excerpt: post.excerpt,
        tags: post.tags,
        readingTime: post.readingTime,
        content: { blocks: post.blocks },
      },
      create: {
        title: post.title,
        slug: post.slug,
        category: post.category,
        excerpt: post.excerpt,
        tags: post.tags,
        readingTime: post.readingTime,
        content: { blocks: post.blocks },
        authorId: editor.id,
        status: "published",
        publishedAt: new Date(),
      },
    });
  }

  for (const job of JOBS) {
    await prisma.job.upsert({
      where: { slug: job.slug },
      update: {
        title: job.title,
        department: job.department,
        location: job.location,
        type: job.type,
        description: job.description,
        requirements: job.requirements,
      },
      create: { ...job, status: "open" },
    });
  }

  console.log(
    `Seed complete: ${STATES.length} states, ${CITIES.length} cities, ${builders.length} builders, ${projectIndex} projects, ${BLOG_POSTS.length} blog posts, ${JOBS.length} jobs.`
  );
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
