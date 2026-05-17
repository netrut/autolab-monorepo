import { Hero } from '@/components/sections/hero';
import { Features } from '@/components/sections/features';
import { HowItWorks } from '@/components/sections/how-it-works';
import { Stats } from '@/components/sections/stats';
import { CTA } from '@/components/sections/cta';
import { FAQ } from '@/components/sections/faq';

export default function HomePage() {
  return (
    <>
      <Hero />
      <Features />
      <HowItWorks />
      <Stats />
      <FAQ />
      <CTA />
    </>
  );
}
