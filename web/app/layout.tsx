import type { ReactNode } from "react";
export const metadata = { title: "PrepJudge", description: "Interview practice platform" };
export default function Layout({children}: {children: ReactNode}) { return <html lang="en"><body style={{fontFamily:"system-ui",margin:"4rem auto",padding:"0 1.5rem",maxWidth:800}}>{children}</body></html>; }
