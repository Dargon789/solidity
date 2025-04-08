/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#include <libevmasm/Ethdebug.h>

#include <range/v3/algorithm/any_of.hpp>

using namespace solidity;
using namespace solidity::evmasm;
using namespace solidity::evmasm::ethdebug;

namespace
{

std::vector<Json> codeSectionInstructions(Assembly const& _assembly, LinkerObject const& _linkerObject, unsigned _sourceId, size_t const _codeSectionIndex)
{
	solAssert(_codeSectionIndex < _linkerObject.codeSectionLocations.size());
	solAssert(_codeSectionIndex < _assembly.codeSections().size());
	auto const& locations = _linkerObject.codeSectionLocations[_codeSectionIndex];
	auto const& codeSection = _assembly.codeSections().at(_codeSectionIndex);

	std::vector<Json> instructions;
	instructions.reserve(codeSection.items.size());

	bool const codeSectionContainsVerbatim = ranges::any_of(
		codeSection.items,
		[](auto const& _instruction) { return _instruction.type() == VerbatimBytecode; }
	);
	solUnimplementedAssert(!codeSectionContainsVerbatim, "Verbatim bytecode is currently not supported by ethdebug.");

	for (auto const& currentInstruction: locations.instructionLocations)
	{
		size_t const start = currentInstruction.start;
		size_t const end = currentInstruction.end;

		// some instructions do not contribute to the bytecode
		if (start == end)
			continue;

		size_t const assemblyItemIndex = currentInstruction.assemblyItemIndex;
		solAssert(end <= _linkerObject.bytecode.size());
		solAssert(start < end);
		solAssert(assemblyItemIndex < codeSection.items.size());
		Json operation = Json::object();
		operation["mnemonic"] = instructionInfo(static_cast<Instruction>(_linkerObject.bytecode[start]), _assembly.evmVersion()).name;
		static size_t constexpr instructionSize = 1;
		if (start + instructionSize < end)
		{
			bytes const argumentData(
				_linkerObject.bytecode.begin() + static_cast<std::ptrdiff_t>(start) + instructionSize,
				_linkerObject.bytecode.begin() + static_cast<std::ptrdiff_t>(end)
			);
			solAssert(!argumentData.empty());
			operation["arguments"] = Json::array({util::toHex(argumentData, util::HexPrefix::Add)});
		}
		langutil::SourceLocation const& location = codeSection.items.at(assemblyItemIndex).location();
		instructions.emplace_back(Json{
			{ "offset", start },
			{"operation", operation },
			{
				"context", {
					"code", {
						"source", {
							{ "id", static_cast<int>(_sourceId) },
						},
						"range", {
							{ "offset", location.start },
							{ "length", location.end - location.start }
						}
					}
				}
			}
		});
	}

	return instructions;
}

Json programInstructions(Assembly const& _assembly, LinkerObject const& _linkerObject, unsigned _sourceId)
{
	auto const numCodeSections = _assembly.codeSections().size();
	solAssert(numCodeSections == _linkerObject.codeSectionLocations.size());

	std::vector<Json> instructionInfo;
	for (size_t codeSectionIndex = 0; codeSectionIndex < numCodeSections; ++codeSectionIndex)
		instructionInfo += codeSectionInstructions(_assembly, _linkerObject, _sourceId, codeSectionIndex);
	return instructionInfo;
}

} // anonymous namespace

Json ethdebug::program(std::string_view _name, unsigned _sourceId, Assembly const& _assembly, LinkerObject const& _linkerObject)
{
	Json result = Json::object();
	result["contract"] = Json::object();
	result["contract"]["name"] = _name;
	result["contract"]["definition"] = Json::object();
	result["contract"]["definition"]["source"] = Json::object();
	result["contract"]["definition"]["source"]["id"] = _sourceId;
	if (_assembly)
	{
		result["environment"] = _assembly->isCreation() ? "create" : "call";
		result["instructions"] = programInstructions(*_assembly, _linkerObject, _sourceId);
	}
	return result;
}

Json ethdebug::resources(std::vector<std::string> const& _sources, std::string const& _version)
{
	Json sources = Json::array();
	for (size_t id = 0; id < _sources.size(); ++id)
	{
		Json source = Json::object();
		source["id"] = id;
		source["path"] = _sources[id];
		sources.push_back(source);
	}
	Json result = Json::object();
	result["compilation"] = Json::object();
	result["compilation"]["compiler"] = Json::object();
	result["compilation"]["compiler"]["name"] = "solc";
	result["compilation"]["compiler"]["version"] = _version;
	result["compilation"]["sources"] = sources;
	return result;
}
