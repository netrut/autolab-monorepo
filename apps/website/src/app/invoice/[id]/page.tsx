import { notFound } from 'next/navigation';

const API = 'https://autolab-api.vercel.app';

async function getInvoice(id: string) {
  try {
    const res = await fetch(`${API}/api/invoices/public/${id}`, { cache: 'no-store' });
    if (!res.ok) return null;
    return res.json();
  } catch {
    return null;
  }
}

export default async function InvoicePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const inv = await getInvoice(id);
  if (!inv) notFound();

  const svc = inv.service;
  const date = new Date(inv.service_date).toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4">
      <div className="max-w-xl mx-auto bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">

        {/* Header */}
        <div className="bg-gray-900 text-white px-6 py-5 flex justify-between items-start">
          <div>
            <p className="text-xs tracking-widest text-gray-400 mb-1">AUTOLAB</p>
            <p className="text-lg font-bold">{inv.service_centre_name ?? 'Service Centre'}</p>
          </div>
          <div className="text-right">
            <span className="text-xs bg-green-500 text-white px-2 py-1 rounded-full font-semibold">INVOICE</span>
            <p className="text-sm font-semibold mt-1">{inv.invoice_number}</p>
            <p className="text-xs text-gray-400">{date}</p>
          </div>
        </div>

        <div className="px-6 py-5 space-y-5">

          {/* Vehicle */}
          {svc && (
            <div>
              <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">Vehicle Details</p>
              <div className="bg-gray-50 rounded-xl p-4 space-y-1 text-sm text-gray-700">
                <p>🚗 {[svc.vehicle_brand, svc.vehicle_model].filter(Boolean).join(' ')}{svc.registration_number ? ` — ${svc.registration_number}` : ''}</p>
                <p>🔧 {svc.service_type?.charAt(0).toUpperCase()}{svc.service_type?.slice(1)} Service</p>
                {svc.odometer_km && <p>📍 {svc.odometer_km} km</p>}
              </div>
            </div>
          )}

          {/* Items */}
          {svc?.items?.length > 0 && (
            <div>
              <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">Service Items</p>
              <div className="border border-gray-100 rounded-xl overflow-hidden">
                <div className="grid grid-cols-12 bg-gray-50 px-4 py-2 text-xs font-semibold text-gray-600">
                  <span className="col-span-6">Item</span>
                  <span className="col-span-3">Status</span>
                  <span className="col-span-3 text-right">Cost</span>
                </div>
                {svc.items.map((item: any, i: number) => (
                  <div key={i} className="grid grid-cols-12 px-4 py-2 text-sm border-t border-gray-100">
                    <span className="col-span-6 text-gray-800">{item.item_name}</span>
                    <span className="col-span-3 text-gray-500">{item.status}</span>
                    <span className="col-span-3 text-right text-gray-800">₹{Number(item.cost).toFixed(0)}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Cost Summary */}
          <div>
            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">Cost Summary</p>
            <div className="bg-gray-50 rounded-xl p-4 space-y-2 text-sm">
              <div className="flex justify-between text-gray-600"><span>Items Subtotal</span><span>₹{Number(inv.items_cost).toFixed(0)}</span></div>
              <div className="flex justify-between text-gray-600"><span>Labour</span><span>₹{Number(inv.labour_cost).toFixed(0)}</span></div>
              <div className="border-t border-gray-200 pt-2 flex justify-between font-bold text-gray-900 text-base">
                <span>Total</span><span>₹{Number(inv.total_cost).toFixed(0)}</span>
              </div>
            </div>
          </div>

          {/* Footer */}
          {inv.footer_text && (
            <p className="text-center text-xs text-blue-500 italic border border-blue-100 bg-blue-50 rounded-xl px-4 py-3">
              {inv.footer_text}
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
