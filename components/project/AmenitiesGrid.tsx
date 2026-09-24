import {
  ArrowUpDown,
  BatteryCharging,
  Baby,
  Building,
  CloudRain,
  Dumbbell,
  Flower2,
  Footprints,
  Gamepad2,
  ParkingCircle,
  Phone,
  Siren,
  ShieldCheck,
  Sofa,
  TreePine,
  Users,
  Waves,
  Zap,
  type LucideIcon,
} from "lucide-react";

const AMENITY_META: Record<string, { label: string; icon: LucideIcon }> = {
  swimming_pool: { label: "Swimming Pool", icon: Waves },
  gym: { label: "Gym", icon: Dumbbell },
  clubhouse: { label: "Clubhouse", icon: Users },
  garden: { label: "Landscaped Garden", icon: TreePine },
  security_247: { label: "24/7 Security", icon: ShieldCheck },
  parking: { label: "Parking", icon: ParkingCircle },
  power_backup: { label: "Power Backup", icon: Zap },
  play_area: { label: "Play Area", icon: Baby },
  lift: { label: "High-Speed Lifts", icon: ArrowUpDown },
  indoor_games: { label: "Indoor Games Room", icon: Gamepad2 },
  jogging_track: { label: "Jogging Track", icon: Footprints },
  yoga_deck: { label: "Yoga & Meditation Deck", icon: Flower2 },
  senior_citizen_area: { label: "Senior Citizen Sit-out", icon: Sofa },
  rainwater_harvesting: { label: "Rainwater Harvesting", icon: CloudRain },
  intercom: { label: "Intercom Facility", icon: Phone },
  fire_safety: { label: "Fire Safety", icon: Siren },
  community_hall: { label: "Community Hall", icon: Building },
  ev_charging: { label: "EV Charging Station", icon: BatteryCharging },
};

function isAmenitiesJson(value: unknown): value is Record<string, boolean> {
  return typeof value === "object" && value !== null;
}

export function AmenitiesGrid({ amenities }: { amenities: unknown }) {
  if (!isAmenitiesJson(amenities)) return null;
  const active = Object.entries(amenities).filter(([key, value]) => value && AMENITY_META[key]);
  if (active.length === 0) return null;

  return (
    <section className="space-y-4">
      <h2 className="text-xl font-bold">Amenities</h2>
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
        {active.map(([key]) => {
          const meta = AMENITY_META[key];
          const Icon = meta.icon;
          return (
            <div
              key={key}
              className="flex items-center gap-2.5 rounded-xl border bg-card p-3 text-sm shadow-sm transition-colors hover:border-primary/40"
            >
              <span className="flex size-9 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary">
                <Icon className="size-4" />
              </span>
              {meta.label}
            </div>
          );
        })}
      </div>
    </section>
  );
}
