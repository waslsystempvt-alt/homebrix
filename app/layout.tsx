import type { Metadata } from "next";
import { Plus_Jakarta_Sans, Fraunces, Geist_Mono } from "next/font/google";
import { Header } from "@/components/layout/Header";
import { Footer } from "@/components/layout/Footer";
import { CompareBar } from "@/components/compare/CompareBar";
import { LeadPopupProvider } from "@/components/cta/LeadPopupProvider";
import "./globals.css";

const fontSans = Plus_Jakarta_Sans({
  variable: "--font-sans",
  subsets: ["latin"],
});

/** Editorial display face — used for h1/h2 only, so the UI stays in the sans. */
const fontDisplay = Fraunces({
  variable: "--font-display",
  subsets: ["latin"],
  display: "swap",
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "New Builder Projects in India | Under Construction Flats | Homebrix",
  description:
    "Find verified under-construction and new launch builder projects across India. RERA verified, zero brokerage, AI-powered search.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html
      lang="en"
      className={`${fontSans.variable} ${fontDisplay.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col" suppressHydrationWarning>
        <LeadPopupProvider>
          <Header />
          <main className="flex-1">{children}</main>
          <Footer />
          <CompareBar />
        </LeadPopupProvider>
      </body>
    </html>
  );
}
