import type { LandmarkCategory } from "@/generated/prisma/client";

export interface LandmarkSeoContent {
  title: string;
  description: string;
  heading: string;
  intro: string;
  schemaType: string;
}

const CATEGORY_SCHEMA_MAP: Record<string, string> = {
  hospital: "Hospital",
  clinic: "MedicalClinic",
  pharmacy: "Pharmacy",
  school: "School",
  college_university: "EducationalOrganization",
  university: "EducationalOrganization",
  coaching: "EducationalOrganization",
  railway_station: "TrainStation",
  metro_station: "SubwayStation",
  bus_stop: "BusStop",
  bus_depot: "BusStation",
  airport: "Airport",
  expressway: "CivicStructure",
  highway: "CivicStructure",
  mall: "ShoppingCenter",
  market: "Market",
  supermarket: "GroceryStore",
  restaurant: "Restaurant",
  hotel: "Hotel",
  cinema: "MovieTheater",
  park: "Park",
  garden: "Park",
  temple: "PlaceOfWorship",
  mosque: "PlaceOfWorship",
  church: "PlaceOfWorship",
  gurudwara: "PlaceOfWorship",
  bank: "BankOrCreditUnion",
  it_park: "OfficeBuilding",
  sez: "OfficeBuilding",
  business_park: "OfficeBuilding",
};

export function getSchemaTypeForCategory(category: LandmarkCategory | string): string {
  return CATEGORY_SCHEMA_MAP[category] || "Place";
}

export function generateLandmarkSeoContent(
  placeName: string,
  cityName: string,
  category: LandmarkCategory | string,
  projectCount: number
): LandmarkSeoContent {
  const schemaType = getSchemaTypeForCategory(category);
  const formattedCategory = category.replace(/_/g, " ");

  let categoryCopy = `residential properties with easy access to ${placeName}`;

  if (["hospital", "clinic"].includes(category)) {
    categoryCopy = `homes located near emergency & top healthcare facilities at ${placeName}`;
  } else if (["railway_station", "metro_station", "bus_depot"].includes(category)) {
    categoryCopy = `apartments with seamless daily transit connectivity near ${placeName}`;
  } else if (["school", "college_university", "university"].includes(category)) {
    categoryCopy = `family apartments close to top educational institutes near ${placeName}`;
  } else if (["mall", "market", "supermarket"].includes(category)) {
    categoryCopy = `lifestyle flats near major shopping and entertainment hubs at ${placeName}`;
  } else if (["it_park", "sez", "business_park"].includes(category)) {
    categoryCopy = `apartments close to major employment centers and IT hubs near ${placeName}`;
  }

  const title = `Flats & Projects near ${placeName}, ${cityName} | Homebrix`;
  const description = `Explore ${projectCount} verified new launch projects and flats near ${placeName} in ${cityName}. Check prices, carpet areas, floor plans, and travel distance.`;
  const heading = `New Projects & Flats near ${placeName}, ${cityName}`;
  const intro = `Looking for ${categoryCopy} in ${cityName}? Browse verified new launch projects, under-construction towers, and ready-to-move apartments within short travel distance of ${placeName}. View complete project details, RERA registrations, floor plans, and builder credentials on Homebrix.`;

  return {
    title,
    description,
    heading,
    intro,
    schemaType,
  };
}
