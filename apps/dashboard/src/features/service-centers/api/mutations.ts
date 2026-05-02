import { mutationOptions } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { createServiceCenter, updateServiceCenter, deactivateServiceCenter } from './service';
import { serviceCenterKeys } from './queries';
import type { ServiceCenterMutationPayload } from './types';

export const createServiceCenterMutation = mutationOptions({
  mutationFn: (data: ServiceCenterMutationPayload) => createServiceCenter(data),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: serviceCenterKeys.all })
});

export const updateServiceCenterMutation = mutationOptions({
  mutationFn: ({ id, values }: { id: string; values: Partial<ServiceCenterMutationPayload> }) =>
    updateServiceCenter(id, values),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: serviceCenterKeys.all })
});

export const deactivateServiceCenterMutation = mutationOptions({
  mutationFn: (id: string) => deactivateServiceCenter(id),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: serviceCenterKeys.all })
});
