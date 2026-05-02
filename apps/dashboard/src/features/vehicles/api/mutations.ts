import { mutationOptions } from '@tanstack/react-query';
import { getQueryClient } from '@/lib/query-client';
import { createVehicle, updateVehicle, deactivateVehicle } from './service';
import { vehicleKeys } from './queries';
import type { VehicleMutationPayload } from './types';

export const createVehicleMutation = mutationOptions({
  mutationFn: (data: VehicleMutationPayload) => createVehicle(data),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: vehicleKeys.all })
});

export const updateVehicleMutation = mutationOptions({
  mutationFn: ({ id, values }: { id: string; values: Partial<VehicleMutationPayload> }) =>
    updateVehicle(id, values),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: vehicleKeys.all })
});

export const deactivateVehicleMutation = mutationOptions({
  mutationFn: (id: string) => deactivateVehicle(id),
  onSuccess: () => getQueryClient().invalidateQueries({ queryKey: vehicleKeys.all })
});
