import Link from "next/link";
import { LayoutDashboard, Building2, Users, Landmark, Newspaper, Briefcase, FileUser, LogOut, MapPin } from "lucide-react";
import { Button } from "@/components/ui/button";
import { logoutAction } from "@/app/admin/login/actions";

const NAV = [
  { href: "/admin", label: "Dashboard", icon: LayoutDashboard },
  { href: "/admin/projects", label: "Projects", icon: Building2 },
  { href: "/admin/leads", label: "Leads", icon: Users },
  { href: "/admin/builders", label: "Builders", icon: Landmark },
  { href: "/admin/places", label: "Places / POIs", icon: MapPin },
  { href: "/admin/blog", label: "Blog", icon: Newspaper },
  { href: "/admin/jobs", label: "Jobs", icon: Briefcase },
  { href: "/admin/job-applications", label: "Job Applications", icon: FileUser },
];

export default function AdminDashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen flex">
      <aside className="w-56 shrink-0 border-r bg-muted/20 flex flex-col">
        <div className="p-4 font-bold border-b">Homebrix Admin</div>
        <nav className="flex-1 p-2 space-y-1">
          {NAV.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="flex items-center gap-2 px-3 py-2 rounded-md text-sm hover:bg-muted"
            >
              <item.icon className="size-4" />
              {item.label}
            </Link>
          ))}
        </nav>
        <form action={logoutAction} className="p-2 border-t">
          <Button type="submit" variant="ghost" size="sm" className="w-full justify-start">
            <LogOut className="size-4" /> Log Out
          </Button>
        </form>
      </aside>
      <main className="flex-1 p-8 overflow-x-auto">{children}</main>
    </div>
  );
}
