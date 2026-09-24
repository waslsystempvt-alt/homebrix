const STATS = [
  { value: "500+", label: "PROJECTS TO EXPLORE" },
  { value: "80+", label: "BUILDER PARTNERS" },
  { value: "12+", label: "CITIES. ENDLESS POSSIBILITIES." },
  { value: "10K+", label: "HOME BUYING JOURNEYS" },
];
export function TrustStatsBar() {
  return <div className="home-trust">{STATS.map(stat => <div key={stat.label}><strong>{stat.value}</strong><span>{stat.label}</span></div>)}</div>;
}
