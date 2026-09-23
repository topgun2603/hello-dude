/**
 * Call audio kept for safety reports (kit: "On a report, keep the call audio,
 * delete it after the report is closed").
 *
 * Production: LiveKit Egress writes room audio to the private bucket. That
 * needs LiveKit Cloud (or a self-hosted egress worker) and S3 credentials, so
 * until those exist the recorder is disabled and reports say so.
 */
export interface Recorder {
  readonly enabled: boolean;
  /** Starts recording the room's audio. Returns an id to stop it with, and where the file will be. */
  start(room: string, reportId: string): Promise<{ egressId: string; storageKey: string }>;
  stop(egressId: string): Promise<void>;
}

export const disabledRecorder: Recorder = {
  enabled: false,
  async start() { throw new Error("recording disabled"); },
  async stop() {},
};
