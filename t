it("Should update modifiedRows with new OUTLIER_STATUS", () => {
  const instance = wrapper.children().instance();
  const event = {
    data: { NODE_ID: "N1", NODE_NAME: "Node 1" },
    colDef: { field: "OUTLIER_STATUS" },
    newValue: "CRITICAL",
    node: { rowIndex: "row-1" }
  };

  instance.onCellValueChanged(event);

  expect(instance.state.modifiedRows["row-1"]).toEqual({
    NODE_ID: "N1",
    NODE_NAME: "Node 1",
    OUTLIER_STATUS: "CRITICAL"
  });
});

it("Should remove field if new value is empty", () => {
  const instance = wrapper.children().instance();

  instance.setState({
    modifiedRows: {
      "row-2": {
        OUTLIER_STATUS: "CRITICAL",
        COMMENT: "Check this"
      }
    }
  });

  const event = {
    data: { OUTLIER_STATUS: "CRITICAL", COMMENT: "Check this" },
    colDef: { field: "OUTLIER_STATUS" },
    newValue: "",
    node: { rowIndex: "row-2" }
  };

  instance.onCellValueChanged(event);

  expect(instance.state.modifiedRows["row-2"]).toEqual({
    COMMENT: "Check this"
  });
});

it("Should delete entire row when tracked fields are empty", () => {
  const instance = wrapper.children().instance();

  instance.setState({
    modifiedRows: {
      "row-3": {
        OUTLIER_STATUS: "Warning",
        COMMENT: "Important"
      }
    }
  });

  const event = {
    data: {},
    colDef: { field: "COMMENT" },
    newValue: "",
    node: { rowIndex: "row-3" }
  };

  instance.onCellValueChanged(event);

  expect(instance.state.modifiedRows["row-3"]).toBeUndefined();
});

it("Should not change modifiedRows when non-tracked field is updated", () => {
  const instance = wrapper.children().instance();

  instance.setState({
    modifiedRows: {
      "row-4": {
        NODE_ID: "N4",
        OUTLIER_STATUS: "OK"
      }
    }
  });

  const event = {
    data: { NODE_ID: "N4" },
    colDef: { field: "UNTRACKED_FIELD" },
    newValue: "Random",
    node: { rowIndex: "row-4" }
  };

  instance.onCellValueChanged(event);

  expect(instance.state.modifiedRows["row-4"]).toEqual({
    NODE_ID: "N4",
    OUTLIER_STATUS: "OK"
  });
});
