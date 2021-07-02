let str = React.string

let cmvOptionsArray: array<Options.t> = [
  {label: "Volume Control Ventilation (VCV)", value: "VCV", name: "cmv"},
  {label: "Pressure Control Ventilation (PCV)", value: "PCV", name: "cmv"},
  {
    label: "Pressure Regulated Volume Controlled Ventilation (PRVC)",
    value: "PRVC",
    name: "cmv",
  },
  {label: "Airway Pressure Release Ventilation (APRV)", value: "APRV", name: "cmv"},
]

let simvOptionArray: array<Options.t> = [
  {label: "Volume Controlled SIMV (VC-SIMV)", value: "VC_SIMV", name: "simv"},
  {label: "Pressure Controlled SIMV (PC-SIMV)", value: "PC_SIMV", name: "simv"},
  {
    label: "Pressure Regulated Volume Controlled SIMV (PRVC-SIMV)",
    value: "PRVC_SIMV",
    name: "simv",
  },
  {label: "Adapative Support Ventilation (ASV)", value: "ASV", name: "simv"},
]

let rhythmOptionArray: array<Options.t> = [
  {label: "Regular", value: "regular", name: "rhythm"},
  {label: "Irregular", value: "irregular", name: "rhythm"},
]

let handleSubmit = (handleDone, state) => {
  handleDone(state)
}

type action =
  | SetBp_systolic(string)
  | SetBp_diastolic(string)
  | SetPulse(string)
  | SetTemperature(string)
  | SetRespiratory_rate(string)
  | SetRhythm(CriticalCare__HemodynamicParametersRhythm.rhythmVar)
  | SetDescription(string)

let reducer = (state, action) => {
  switch action {
  | SetBp_systolic(bp_systolic) => {
      ...state,
      CriticalCare__HemodynamicParameters.bp_systolic: bp_systolic,
    }
  | SetBp_diastolic(bp_diastolic) => {
      ...state,
      CriticalCare__HemodynamicParameters.bp_diastolic: bp_diastolic,
    }
  | SetPulse(pulse) => {...state, CriticalCare__HemodynamicParameters.pulse: pulse}
  | SetTemperature(temperature) => {
      ...state,
      CriticalCare__HemodynamicParameters.temperature: temperature,
    }
  | SetRespiratory_rate(respiratory_rate) => {
      ...state,
      CriticalCare__HemodynamicParameters.respiratory_rate: respiratory_rate,
    }
  | SetRhythm(rhythm) => {...state, CriticalCare__HemodynamicParameters.rhythm: rhythm}
  | SetDescription(description) => {
      ...state,
      CriticalCare__HemodynamicParameters.description: description,
    }
  }
}

let psvOptionsArray = [
  {
    "title": "PEEP (cm/H2O)",
    "start": "0",
    "end": "30",
    "interval": "5",
    "step": 1.0,
  },
  {
    "title": "Peak Inspiratory Pressure (PIP) (cm H2O)",
    "start": "0",
    "end": "100",
    "interval": "10",
    "step": 1.0,
  },
  {
    "title": "Mean Airway Pressure (cm H2O",
    "start": "0",
    "end": "40",
    "interval": "5",
    "step": 1.0,
  },
  {
    "title": "Respiratory Rate Ventilator (bpm)",
    "start": "0",
    "end": "100",
    "interval": "10",
    "step": 1.0,
  },
  {
    "title": "Tidal Volume (ml)",
    "start": "0",
    "end": "1000",
    "interval": "100",
    "step": 1.0,
  },
  {
    "title": "FiO2 (%)",
    "start": "20",
    "end": "100",
    "interval": "10",
    "step": 1.0,
  },
  {
    "title": "SPO2 (%)",
    "start": "0",
    "end": "100",
    "interval": "10",
    "step": 1.0,
  },
]

@react.component
let make = () => {
  let (active, setActive) = React.useState(_ => "")
  let (slider, setSlider) = React.useState(_ => "")

  let handleChange = opt => setActive(_ => opt)

  <div>
    <h4 className="mb-4"> {str("Ventilator Mode")} </h4>
    <div className="mb-4">
      <label onClick={_ => handleChange("cmv")}>
        <input className="mr-2" type_="radio" name="ventilatorMode" value={"cmv"} id={"cmv"} />
        {str({"Control Mechanical Ventilation (CMV)"})}
      </label>
      <div className={`ml-6 ${active !== "cmv" ? "pointer-events-none opacity-50" : ""} `}>
        <CriticalCare__RadioButton options={cmvOptionsArray} horizontal={false} />
      </div>
    </div>
    <div className="mb-4">
      <label onClick={_ => handleChange("simv")}>
        <input className="mr-2" type_="radio" name="ventilatorMode" value={"simv"} id={"simv"} />
        {str({"Synchronised Intermittent Mandatory Ventilation (SIMV)"})}
      </label>
      <div className={`ml-6 ${active !== "simv" ? "pointer-events-none opacity-50" : ""} `}>
        <CriticalCare__RadioButton options={simvOptionArray} horizontal={false} />
      </div>
    </div>
    <div className="mb-4">
      <label onClick={_ => handleChange("psv")}>
        <input className="mr-2" type_="radio" name="ventilatorMode" value={"psv"} id={"psv"} />
        {str({"C-PAP/ Pressure Support Ventilation (PSV)"})}
      </label>
      <div className={`ml-6 ${active !== "psv" ? "pointer-events-none opacity-50" : ""} `}>
        {psvOptionsArray
        |> Array.map(option => {
          <Slider
            title={option["title"]}
            start={option["start"]}
            end={option["end"]}
            interval={option["interval"]}
            step={option["step"]}
            value={slider}
            setValue={s => setSlider(_ => s)}
            getLabel={_ => ("Normal", "#ff0000")}
          />
        })
        |> React.array}
      </div>
    </div>
  </div>
}
