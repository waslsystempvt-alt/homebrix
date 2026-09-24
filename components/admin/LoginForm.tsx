"use client";

import { useActionState } from "react";
import { Card } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { loginAction } from "@/app/admin/login/actions";

export function LoginForm({ next }: { next: string }) {
  const [state, formAction, pending] = useActionState(
    async (_prevState: { error: string } | undefined, formData: FormData) => {
      const result = await loginAction(formData);
      return result ?? undefined;
    },
    undefined
  );

  return (
    <Card className="w-full max-w-sm p-6 space-y-4">
      <div>
        <h1 className="text-xl font-bold">Homebrix Admin</h1>
        <p className="text-sm text-muted-foreground">Sign in to manage projects and leads</p>
      </div>
      <form action={formAction} className="space-y-4">
        <input type="hidden" name="next" value={next} />
        <div className="space-y-1.5">
          <Label htmlFor="password">Password</Label>
          <Input id="password" name="password" type="password" required autoFocus />
        </div>
        {state?.error && <p className="text-sm text-destructive">{state.error}</p>}
        <Button type="submit" className="w-full" disabled={pending}>
          {pending ? "Signing in..." : "Sign In"}
        </Button>
      </form>
    </Card>
  );
}
