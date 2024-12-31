import { useQuery } from "@tanstack/react-query";
import { createContext, useEffect, useState } from "react";

import { SidebarProvider } from "@/components/ui/sidebar";
import { AppSidebar } from "@/components/ui/sidebar/app-sidebar";

import { CarePatientTokenKey } from "@/common/constants";

import routes from "@/Utils/request/api";
import query from "@/Utils/request/query";
import { AppointmentPatient } from "@/pages/Patient/Utils";
import { TokenData } from "@/types/auth/otpToken";

const tokenData: TokenData = JSON.parse(
  localStorage.getItem(CarePatientTokenKey) || "{}",
);

export type PatientUserContextType = {
  patients?: AppointmentPatient[];
  selectedPatient: AppointmentPatient | null;
  setSelectedPatient: (patient: AppointmentPatient) => void;
  tokenData: TokenData;
};

export const PatientUserContext = createContext<PatientUserContextType>({
  patients: undefined,
  selectedPatient: null,
  setSelectedPatient: () => {},
  tokenData: tokenData,
});

interface Props {
  children: React.ReactNode;
}

export default function PatientUserProvider({ children }: Props) {
  const [patients, setPatients] = useState<AppointmentPatient[]>([]);
  const [selectedPatient, setSelectedPatient] =
    useState<AppointmentPatient | null>(null);

  const { data: userData } = useQuery({
    queryKey: ["patients", tokenData.phoneNumber],
    queryFn: query(routes.otp.getPatient, {
      headers: {
        Authorization: `Bearer ${tokenData.token}`,
      },
    }),
    enabled: !!tokenData.token,
  });

  useEffect(() => {
    if (userData?.results && userData.results.length > 0) {
      setPatients(userData.results);
      const localPatient: AppointmentPatient | undefined = JSON.parse(
        localStorage.getItem("selectedPatient") || "{}",
      );
      const selectedPatient =
        userData.results.find((patient) => patient.id === localPatient?.id) ||
        userData.results[0];
      setSelectedPatient(selectedPatient);
      localStorage.setItem("selectedPatient", JSON.stringify(selectedPatient));
    }
  }, [userData]);

  const patientUserContext: PatientUserContextType = {
    patients,
    selectedPatient,
    setSelectedPatient,
    tokenData,
  };

  return (
    <PatientUserContext.Provider value={patientUserContext}>
      <SidebarProvider>
        <AppSidebar
          patientUserContext={patientUserContext}
          facilitySidebar={false}
        />
        {children}
      </SidebarProvider>
    </PatientUserContext.Provider>
  );
}