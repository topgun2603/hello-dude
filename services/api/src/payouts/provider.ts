/**
 * UPI payouts (RazorpayX or Cashfree Payouts in production). Until an account
 * exists, the simulator pays instantly — except UPI IDs containing "fail",
 * which fail, so the reversal path can be tried end to end.
 */
export interface PayoutRequest { payoutId: string; upiId: string; amountPaise: number; name: string }
export type PayoutResult =
  | { status: "paid"; providerRef: string }
  | { status: "processing"; providerRef: string }   // provider will confirm by webhook
  | { status: "failed"; reason: string };

export interface PayoutProvider {
  readonly name: string;
  send(req: PayoutRequest): Promise<PayoutResult>;
}

export function simulatedPayouts(): PayoutProvider {
  return {
    name: "simulator",
    async send(req) {
      if (/fail/i.test(req.upiId)) return { status: "failed", reason: "UPI ID rejected by bank (simulated)" };
      return { status: "paid", providerRef: `sim_${req.payoutId.slice(0, 8)}` };
    },
  };
}
