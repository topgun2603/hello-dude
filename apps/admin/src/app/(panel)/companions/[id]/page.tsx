import { UserDetail } from "@/components/user-detail";

export default async function CompanionDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  return <UserDetail id={id} role="companion" />;
}
