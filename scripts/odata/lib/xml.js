class XmlWriter {
  visitor(type, node, name) {
    switch (type) {
      //根节点
      case "document":
        return this.visitDocument(node);

      case "EntityType":
        return this.visitEntityType(node, name);

      case "Property":
        return XmlWriter.visitProperty(node, name);

      case "EntityContainer":
        return this.visitEntityContainter(node);

      case "EntitySet":
        return XmlWriter.visitEntitySet(node, name);

      case "TypeDefinition":
        return XmlWriter.visitTypeDefinition(node, name);

      case "ComplexType":
        return this.visitComplexType(node, name);

      case "Action":
        return XmlWriter.visitAction(node, name);

      case "Function":
        return XmlWriter.visitFunction(node, name);

      case "FunctionImport":
        return XmlWriter.visitFunctionImport(node, name);

      default:
        throw new Error(`Type ${type} is not supported`);
    }
  }

  visitDocument(node) {
    let body = "";

    Object.keys(node).forEach((subnode) => {
      if (node[subnode].$Kind) {
        body += this.visitor(node[subnode].$Kind, node[subnode], subnode);
      }
    });
    //node.$EntityContainer Namespage
    return `<edmx:Edmx Version="${node.$Version}" xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx">
  <edmx:DataServices xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" m:DataServiceVersion="2.0">
    <Schema xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns="http://schemas.microsoft.com/ado/2007/05/edm" Namespace="${node.$EntityContainer}">
      ${body}
    </Schema>
  </edmx:DataServices>
</edmx:Edmx>`;
  }

  static visitEntitySet(node, name) {
    return `<EntitySet Name="${name}" EntityType="${node.$Type}"/>`;
  }

  //所有表类型定义。
  //node {}
  visitEntityContainter(node) {
    let entitySets = "";
    let functions = "";

    Object.keys(node)
      .filter((item) => item !== "$Kind")
      .forEach((item) => {
        if (node[item].$Type) {
          entitySets += this.visitor("EntitySet", node[item], item);
        } else {
          functions += this.visitor("FunctionImport", node[item], item);
        }
      });
    return `<EntityContainer Name="Container">
      ${entitySets}${functions}
    </EntityContainer>`;
  }

  // node 字段对象{}
  // name 字段名称
  static visitProperty(node, name) {
    let attributes = "";

    if (node.$Nullable === false) {
      attributes += ' Nullable="false"';
    }
    if (node.$MaxLength) {
      attributes += ` MaxLength="${node.$MaxLength}"`;
    }
    if (node.$Collection) {
      attributes += ' Collection="true"';
    }

    return `<Property Name="${name}" Type="${node.$Type}"${attributes}/>`;
  }

  // node表类型，对象{}
  // name表名
  visitEntityType(node, name) {
    let properties = "";

    Object.keys(node)
      .filter((item) => item !== "$Kind" && item !== "$Key")
      .forEach((item) => {
        //表属性
        properties += this.visitor("Property", node[item], item);
      });

    return `<EntityType Name="${name}">
      <Key>
        <PropertyRef Name="${node.$Key}"/>
      </Key>
      ${properties}
    </EntityType>`;
  }

  static visitTypeDefinition(node, name) {
    let attributes = "";

    if (node.$MaxLength) {
      attributes += ` MaxLength="${node.$MaxLength}"`;
    }

    return `<TypeDefinition Name="${name}" UnderlyingType="${node.$UnderlyingType}"${attributes}>
      </TypeDefinition>`;
  }

  visitComplexType(node, name) {
    let properties = "";

    Object.keys(node)
      .filter((item) => item !== "$Kind")
      .forEach((item) => {
        properties += this.visitor("Property", node[item], item);
      });

    return `
    <ComplexType Name="${name}">
      ${properties}
    </ComplexType>`;
  }

  static visitAction(node, name) {
    const isBound = node.$IsBound ? ' IsBound="true"' : "";
    const parameter = node.$Parameter.map((item) => {
      let type = "";

      if (item.$Collection) {
        type = ` Type="Collection(${item.$Type})"`;
      } else if (item.$Type) {
        type = ` Type="${item.$Type}"`;
      }

      return `<Parameter Name="${item.$Name}"${type}/>`;
    });

    return `
    <Action Name="${name}"${isBound}>
      ${parameter}
    </Action>
    `;
  }

  static visitFunction(node, name) {
    const collection = node.$ReturnType.$Collection ? ' Collection="true"' : "";

    return `
    <Function Name="${name}">
      <ReturnType Type="${node.$ReturnType.$Type}"${collection}/>
    </Function>
    `;
  }

  static visitFunctionImport(node, name) {
    return `
    <FunctionImport Name="${name}" Function="${node.$Function}"/>
    `;
  }
  //data根数据。
  //{"document":{}}
  writeXml(data, status) {
    const xml = this.visitor("document", data, "", "")
      .replace(/\s*</g, "<")
      .replace(/>\s*/g, ">");

    return {
      type: "application/xml;charset=utf-8",
      status: status,
      data: `<?xml version="1.0" encoding="utf-8" standalone="yes"?>
${xml}`,
    };
  }
}
module.exports = { XmlWriter };
